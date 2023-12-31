
run:
	@echo ""
	@echo "this is [ jwtx ] service"
	@echo ""
	@echo "make tidy      |  更新 Golang 依赖"
	@echo "-----------------------------------------"
	@echo "make sql       |  合并 sql 文件"
	@echo "make dao       |  生成 dao 文件"
	@echo "-----------------------------------------"
	@echo "make rpc       |  生成 rpc 文件"
	@echo "make rpc-run   |  运行 rpc 服务"
	@echo "make rpc-build |  编译 rpc 服务"
	@echo ""

.PHONY:tidy
tidy:
	go mod tidy

.PHONY:sql
sql:
	cd define/jwtx/db && > mysql.sql && cat mysql/*.sql >> mysql.sql && cp mysql.sql ../../../public/jwtx/deploy/jwtx.sql

.PHONY:dao
dao:
	cd private/jwtx/db && go run . -f ../../../public/jwtx/deploy/jwtx-rpc.yaml

.PHONY:rpc
rpc:
	goctl rpc protoc define/jwtx/jwtx.proto --go_out=public --go-grpc_out=public --zrpc_out=private/jwtx/rpc --style goZero

.PHONY:rpc-run
rpc-run:
	cd private/jwtx/rpc && go run jwtx.go -f ../../../public/jwtx/deploy/jwtx-rpc.yaml

.PHONY:rpc-build
rpc-build:
	cd private/jwtx/rpc && go build jwtx.go && mv jwtx ../../../public/jwtx/deploy/jwtx-rpc
