
var flutterApp = (function () {

    var Command = function () {

        // 原生命令任务基类
        var CommandTask = /** @class */ (function () {
            function CommandTask(triger) {
                this.callbackId = null;
                this.commandTrigger = triger;
            }
            CommandTask.prototype.abort = function () {
                this.commandTrigger.triggerAbort(this.callbackId);
                return this;
            };
            CommandTask.prototype.setCallbackId = function (id) {
                this.callbackId = id;
                return this;
            };
            return CommandTask;
        }());

        function Command(cmd) {
            this.callbackIdSequence = 0;
            this.callbackMap = {};
            this.eventMap = {};
            this.from = "src";
            this.version = Command.sVersion;
            if (cmd) {
                this.callbackIdSequence = cmd.callbackIdSequence;
                this.callbackMap = cmd.callbackMap;
                this.eventMap = cmd.eventMap;
            }
        }

        Command.prototype.setNavigationBarConfig = function (options) {
            var allowKeys = ["title", "style", "backgroundColor", "foregroundColor"];
            var usableKeys = [];
            // 此方法允许只传入部分属性,为了过滤自动生成的默认值,加入了usableKeys字段,记录外部传入的key
            for (var key in options) {
                if (options.hasOwnProperty(key)) {
                    if (allowKeys.indexOf(key) >= 0) {
                        usableKeys.push(key);
                    }
                }
            }
            options.usableKeys = usableKeys;
            return this.exec("setNavigationBarConfig", options);
        };
        Command.prototype.getNavigationBarConfig = function (options) {
            return this.exec("getNavigationBarConfig", options);
        };


        Command.prototype.internalExecWithCallbackId = function (callbackId, cmd, params) {
            if (this.check(callbackId, cmd, params)) {
                params = this.transParams(cmd, params);
                var win = window;
                var message = {
                    callbackId: callbackId,
                    command: cmd,
                    params: params,
                };
                if (win.webkit && win.webkit.messageHandlers &&
                    win.webkit.messageHandlers.command &&
                    win.webkit.messageHandlers.command.postMessage) {
                    // iOS
                    win.webkit.messageHandlers.command.postMessage(message);
                }
                else if (win.command && win.command.postMessage) {
                    // Android
                    win.command.postMessage(JSON.stringify(message));
                }
                else {
                    // Others
                    win.console.log(message);
                    this.triggerFail(message.callbackId, "ERR_COMMAND_EXEC", null);
                }
            }
        };
        Command.prototype.internalExec = function (cmd, options, task) {
            var id = "callback_" + this.callbackIdSequence++;
            if (task) {
                task.setCallbackId(id);
            }
            this.callbackMap[id] = {
                fail: options && options.fail,
                success: options && options.success,
                task: task,
                cmd: cmd
            };
            delete options.fail;
            delete options.success;
            this.internalExecWithCallbackId(id, cmd, options);
        };
        Command.prototype.exec = function (cmd, options) {
            this.internalExec(cmd, options, null);
            return this;
        };
        Command.prototype.execTask = function (cmd, options, task) {
            this.internalExec(cmd, options, task);
        };
        Command.sVersion = "1.1.1.1";
        return Command
    }

    return Command;
})();
