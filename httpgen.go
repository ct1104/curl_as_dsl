package main

import (
	"./go_client"
	"./httpgen_common"
	"./java_client"
	"./nodejs_client"
	"./objc_client"
	"./python_client"
	"./xhr_client"
	"bytes"
	"fmt"
	"github.com/jessevdk/go-flags"
	"log"
	"os"
	"reflect"
	"text/template"
)

type GlobalOptions struct {
	Target string `short:"t" long:"target" value-name:"NAME" description:"Target name of code generator" default:"go_client"`
	Debug  bool   `short:"d" long:"debug" description:"Debug option"`
}

func PrintLangHelp(target string) {
	fmt.Fprintf(os.Stderr, `
'%s' is not supported as a target.
This program supports one of the following targets:
* go (default) : Go standard library (net/http)
* python       : Python standard library (http.client)
* nodejs       : Node.js standard library (http/https.request)
* xhr          : JavaScript for browsers standard API (XMLHttpRequest)
* java         : Java standard library (HttpURLConnection/HttpsURLConnection)
* objc         : Objective-C standard library (NSURLConnection)
`, target)
}

func render(lang, key string, options interface{}) string {
	src, _ := Asset(fmt.Sprintf("templates/%s_%s.tpl", lang, key))
	tpl := template.Must(template.New(key).Parse(string(src)))
	var buffer bytes.Buffer
	err := tpl.Execute(&buffer, options)
	if err != nil {
		log.Fatal(err)
	}
	return buffer.String()
}

func main() {
	var globalOptions GlobalOptions
	var curlOptions httpgen_common.CurlOptions
	curlOptions.Init()

	parser := flags.NewParser(&globalOptions, flags.Default)
	curlCommand, err := parser.AddCommand("curl",
		"Generate code from curl options",
		"This command has almost same options of curl and generate code",
		&curlOptions)
	urls, err := parser.Parse()
	if err != nil {
		os.Exit(1)
	}
	if len(urls) > 1 {
		fmt.Println("It accept only one url. Remained urls are ignored.")
	}
	if parser.Active == curlCommand {
		// --url option has higher priority than params.
		if curlOptions.Url == "" {
			if len(urls) > 0 {
				curlOptions.Url = urls[0]
			} else {
				log.Fatalln("Both --url option and url parameters are missing")
			}
		}
		var langName string
		var templateName string
		var option interface{}

		switch globalOptions.Target {
		case "go_client":
			langName = "go"
			templateName, option = go_client.ProcessCurlCommand(&curlOptions)
		case "go":
			langName = "go"
			templateName, option = go_client.ProcessCurlCommand(&curlOptions)
		case "python_client":
			langName = "python"
			templateName, option = python_client.ProcessCurlCommand(&curlOptions)
		case "python":
			langName = "python"
			templateName, option = python_client.ProcessCurlCommand(&curlOptions)
		case "py":
			langName = "python"
			templateName, option = python_client.ProcessCurlCommand(&curlOptions)
		case "nodejs_client":
			langName = "nodejs"
			templateName, option = nodejs_client.ProcessCurlCommand(&curlOptions)
		case "nodejs":
			langName = "nodejs"
			templateName, option = nodejs_client.ProcessCurlCommand(&curlOptions)
		case "node":
			langName = "nodejs"
			templateName, option = nodejs_client.ProcessCurlCommand(&curlOptions)
		case "java":
			langName = "java"
			templateName, option = java_client.ProcessCurlCommand(&curlOptions)
		case "objc":
			langName = "objc"
			templateName, option = objc_client.ProcessCurlCommand(&curlOptions)
		case "xhr":
			langName = "xhr"
			templateName, option = xhr_client.ProcessCurlCommand(&curlOptions)
		case "browser":
			langName = "xhr"
			templateName, option = xhr_client.ProcessCurlCommand(&curlOptions)
		default:
			PrintLangHelp(globalOptions.Target)
			os.Exit(1)
		}
		if templateName != "" {
			if globalOptions.Debug {
				st := reflect.TypeOf(option)
				v := reflect.ValueOf(option)
				fmt.Fprintf(os.Stderr, "Debug: template name=%s\n", templateName)
				fmt.Fprintf(os.Stderr, "Debug: template context=%s\n", st.Name())
				num := st.NumField()
				for i := 0; i < num; i++ {
					fmt.Fprintf(os.Stderr, "    %s: %s\n", st.Field(i).Name, v.Field(i).String())
				}
			}
			fmt.Println(render(langName, templateName, option))
		}
	}
}
