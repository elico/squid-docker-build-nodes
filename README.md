## To build all packages
```bash
touch ./*/build
bash build-all.sh
```

## To build a specific os package
```bash
touch ./squid-centos-7/build
BUILD_ONLY="squid-centos-7" bash build-all.sh
```

## To clean all old packages
`bash clean-packages.sh packages`

## To clean all ccache
`bash clean-packages.sh ccahce`

## To clean all old build flags
`bash clean-packages.sh build`

## CCACHE sources
- <https://github.com/ccache/ccache/releases/download/v3.7.6/ccache-3.7.6.tar.gz>

## Related Docs
* <https://forums.aws.amazon.com/thread.jspa?threadID=314338>
