#!/bin/bash

set -e

echo "case 1: simple get"
./httpgen -t objc.connection curl http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 2: simple post with data"
./httpgen -t objc.connection curl -d test http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 3: post multiple datas"
./httpgen -t objc.connection curl -d test -d hello http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 4: post url encoded data"
./httpgen -t objc.connection curl --data-urlencode="test% =" http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 5: get with parameter"
./httpgen -t objc.connection curl -G -d hello http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 6: get with aprameter (key=value style)"
./httpgen -t objc.connection curl -G -d hello=world http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 7: post with aprameter (key=value style)"
./httpgen -t objc.connection curl -X POST -G -d hello=world http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 8: simple post without data"
./httpgen -t objc.connection curl -X POST http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 9: simple post with local file content"
./httpgen -t objc.connection curl -X POST -T test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 10: post form"
./httpgen -t objc.connection curl -F hello=world http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 10-2: post form (2)"
./httpgen -t objc.connection curl -F hello=world -F good=morning http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 11: post text data from local file"
./httpgen -t objc.connection curl --data-ascii @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 12: post text data from local files"
./httpgen -t objc.connection curl --data-ascii @test.m --data-ascii @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 13: post data from local file"
./httpgen -t objc.connection curl --data-binary @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 14: post data from local files"
./httpgen -t objc.connection curl --data-binary @test.m --data-binary @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 15: post url encoded data from local file"
./httpgen -t objc.connection curl --data-urlencode @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 16: post url encoded data from local files"
./httpgen -t objc.connection curl --data-urlencode @test.m --data-urlencode @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 17: send file in form protocol"
./httpgen -t objc.connection curl -F "file=@test.m" http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 18: send file in form protocol with explicit name and type"
./httpgen -t objc.connection curl -F "file=@test.m;filename=nameinpost;type=text/plain" http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 19: send file in form protocol (2)"
./httpgen -t objc.connection curl -F "file=<test.m" http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 20: send file in form protocol with explicit type (2)"
./httpgen -t objc.connection curl -F "file=<test.m;type=text/plain" http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 21: get with aprameter and header"
./httpgen -t objc.connection curl -H "Accept: text/html" -G -d hello=world http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 22: simple post with data and user-agent"
./httpgen -t objc.connection curl --user-agent="Netscape 4.7" -d test http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 23: post url encoded data from local files with compressed option"
./httpgen -t objc.connection curl --compressed --data-urlencode @test.m --data-urlencode @test.m http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

echo "case 24: Basic authentication"
./httpgen -t objc.connection curl -u USER:PASS http://localhost:18888 > test/test.m
pushd test;clang test.m -framework Foundation -framework AppKit -o test;./test;popd

