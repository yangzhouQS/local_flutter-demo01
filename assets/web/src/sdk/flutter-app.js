
var FlutterAPP = (function () {
    'use strict';

    var checkRule = function (rule) {
        return true;
    }
    var Command = (function () {
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

        Command.prototype.test = function () {
            return "test 测试正常"
        };

        // -----------share------
        Command.prototype.showShareModal = function (options) {
            return this.exec("showShareModal", options);
        };
        // -----------media------audio
        Command.prototype.playVoice = function (options) {
            return this.exec("playVoice", options);
        };
        Command.prototype.pauseVoice = function (options) {
            return this.exec("pauseVoice", options);
        };
        Command.prototype.stopVoice = function (options) {
            return this.exec("stopVoice", options);
        };
        Command.prototype.startRecord = function (options) {
            return this.exec("startRecord", options);
        };
        Command.prototype.stopRecord = function (options) {
            return this.exec("stopRecord", options);
        };
        Command.prototype.uploadVoice = function (options) {
            var task = new UploadTask(this);
            this.execTask("uploadVoice", options, task);
            return task;
        };
        Command.prototype.onVoicePlayEnd = function (callback) {
            if (typeof callback === "function") {
                this.eventMap["onVoicePlayEnd"] = callback;
            }
        };
        Command.prototype.onVoiceRecordEnd = function (callback) {
            if (typeof callback === "function") {
                this.eventMap["onVoiceRecordEnd"] = callback;
            }
        };
        Command.prototype.chooseImage = function (options) {
            return this.exec("chooseImage", options);
        };
        Command.prototype.chooseAttachments = function (options) {
            return this.exec("chooseAttachments", options);
        };
        Command.prototype.signUp = function (options) {
            return this.exec("signUp", options);
        };
        Command.prototype.previewImage = function (options) {
            return this.exec("previewImage", options);
        };
        Command.prototype.getImageInfo = function (options) {
            return this.exec("getImageInfo", options);
        };
        Command.prototype.saveImageToPhotosAlbum = function (options) {
            return this.exec("saveImageToPhotosAlbum", options);
        };
        Command.prototype.scanCode = function (options) {
            return this.exec("scanCode", options);
        };
        Command.prototype.showHikVision = function (options) {
            return this.exec("showHikVision", options);
        };
        Command.prototype.showHikVisionV2 = function (options) {
            return this.exec("showHikVisionV2", options);
        };
        Command.prototype.showHikVisionV3 = function (options) {
            return this.exec("showHikVisionV3", options);
        };
        Command.prototype.checkSession = function (options) {
            return this.exec("checkSession", options);
        };
        Command.prototype.getUserInfo = function (options) {
            return this.exec("getUserInfo", options);
        };
        Command.prototype.setNavigationBarTitle = function (options) {
            return this.exec("setNavigationBarTitle", options);
        };
        Command.prototype.setCameraTemplate = function (options) {
            return this.exec("setCameraTemplate", options);
        };


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


        Command.prototype.getSystemInfo = function (options) {
            return this.exec("getSystemInfo", options);
        };
        Command.prototype.navigateToHome = function (options) {
            return this.exec("navigateToHome", options);
        };
        Command.prototype.getLocation = function (options) {
            return this.exec("getLocation", options);
        };
        // -----------ble------bluetooth
        Command.prototype.closeBLEConnection = function (options) {
            return this.exec("closeBLEConnection", options);
        };
        Command.prototype.createBLEConnection = function (options) {
            return this.exec("createBLEConnection", options);
        };
        Command.prototype.getBLEDeviceCharacteristics = function (options) {
            return this.exec("getBLEDeviceCharacteristics", options);
        };
        Command.prototype.getBLEDeviceServices = function (options) {
            return this.exec("getBLEDeviceServices", options);
        };
        Command.prototype.onBLEConnectionStateChange = function (callback) {
            if (typeof callback === "function") {
                this.eventMap["onBLEConnectionStateChange"] = callback;
            }
        };
        Command.prototype.writeBLECharacteristicValue = function (options) {
            return this.exec("writeBLECharacteristicValue", options);
        };
        Command.prototype.closeBluetoothAdapter = function (options) {
            return this.exec("closeBluetoothAdapter", options);
        };
        Command.prototype.getBluetoothAdapterState = function (options) {
            return this.exec("getBluetoothAdapterState", options);
        };
        Command.prototype.getBluetoothDevices = function (options) {
            return this.exec("getBluetoothDevices", options);
        };
        // --------------- end ble bluetooth -----------




        // ---------------------------------------------
        Command.prototype.triggerAbort = function (callbackId) {
            if (this.callbackMap[callbackId]) {
                this.internalExecWithCallbackId(callbackId, "taskAbort", {});
            }
        };
        Command.prototype.triggerEvent = function (name, res) {
            if (res === void 0) { res = true; }
            var callback = this.eventMap[name];
            if (callback && typeof callback === "function") {
                res = this.transParams(name, res);
                callback.call(this, res);
            }
        };
        Command.prototype.triggerProgress = function (callbackId, progress, totalBytesSent, totalBytesExpectedToSend) {
            var item = this.callbackMap[callbackId];
            if (item && item.task && item.task instanceof CommandProgressTask) {
                item.task.triggerProgress(progress, totalBytesSent, totalBytesExpectedToSend);
            }
        };
        Command.prototype.triggerSuccess = function (callbackId, data) {
            if (data === void 0) { data = true; }
            var item = this.callbackMap[callbackId];
            if (item) {
                delete this.callbackMap[callbackId];
                this.transCallbackData(item.cmd, data);
                item.success && item.success.call(this, data);
            }
            else {
                // var msg = this.getLocaleMessageConfig("ERR_COMMAND_EXEC_CALLBACK", [callbackId]);
                var msg = `"ERR_COMMAND_EXEC_CALLBACK", [${callbackId}]`;
                window.console.error(msg);
            }
            return 'ok'
        };
        Command.prototype.triggerFail = function (callbackId, key, values, res) {
            var item = this.callbackMap[callbackId];
            if (item) {
                delete this.callbackMap[callbackId];
                /*if ((typeof key) === "number") {
                    key = Command.locale.getLocaleKeyByCode(key);
                }*/
                var locale_1 = this.getLocaleMessageConfig(key, values);
                item.fail && item.fail.call(this, locale_1.errMsg, locale_1, res);
            }
            else {
                var msg = this.getLocaleMessageConfig("ERR_COMMAND_EXEC_CALLBACK", [callbackId]);
                window.console.error(msg);
            }
        };
        Command.prototype.getLocaleMessageConfig = function (key, values) {
            var msgConfig = null;
            key = key || "ERR_COMMAND_INVOKE";
            msgConfig = Command.locale.getLocaleByKey(key);
            values = values || ["-1"];
            values.unshift(msgConfig.errMsg);
            msgConfig.errMsg = format.apply(this, values);
            return msgConfig;
        };
        Command.prototype.transCallbackData = function (cmd, data) {
            if (!cmd || !data) {
                return;
            }
            switch (cmd) {
                case "getBluetoothDevices":
                    this.transParamToArrayBuffer("advertisData", data.devices);
                    break;
            }
        };

        Command.prototype.transParams = function (cmd, params) {
            if (!cmd) {
                return params;
            }
            var paramsToTrans = params;
            switch (cmd) {
                case "writeBLECharacteristicValue":
                    this.tranParamToNumberArray("value", paramsToTrans);
                    break;
                case "onBluetoothDeviceFound":
                    this.transParamToArrayBuffer("advertisData", paramsToTrans.devices);
                    break;
                case "onBLECharacteristicValueChange":
                    this.transParamToArrayBuffer("value", paramsToTrans);
            }
            return paramsToTrans;
        };
        Command.prototype.tranParamToNumberArray = function (key, params) {
            if (!params || !params[key]) {
                return;
            }
            var arr = Array.prototype.slice.call(params[key]);
            params[key] = arr;
        };
        Command.prototype.transParamToArrayBuffer = function (key, params) {
            if (!params || params === null) {
                return;
            }
            if (params instanceof Array) {
                params.forEach(function (item) {
                    if (item[key] && item[key] instanceof Array) {
                        var bufferView = new Uint8Array(item[key]);
                        item[key] = bufferView;
                    }
                });
                return;
            }
            if (params[key] && params[key] instanceof Array) {
                var bufferView = new Uint8Array(params[key]);
                params[key] = bufferView;
            }
        };
        Command.prototype.check = function (callbackId, cmd, params) {
            return checkRule(cmd, params, (function (me, callbackId) {
                return function (key, values) {
                    me.triggerFail(callbackId, key, values);
                };
            })(this, callbackId));
        };
        Command.prototype.internalExecWithCallbackId = function (callbackId, cmd, params) {
            var win = window;

            if (this.check(callbackId, cmd, params)) {
                params = this.transParams(cmd, params);

                var message = {
                    callbackId: callbackId,
                    command: cmd,
                    params: params,
                };
                win.SDKCommand.callHandler("command", message)
                /*var message = {
                    callbackId: callbackId,
                    command: cmd,
                    params: params,
                };
                if (win.webkit && win.webkit.messageHandlers &&
                    win.webkit.messageHandlers.command &&
                    win.webkit.messageHandlers.command.postMessage) {
                    // iOS
                    win.webkit.messageHandlers.command.postMessage(message);
                } else if (win.SDKCommand && win.SDKCommand.postMessage) {
                    // Android
                    win.SDKCommand.postMessage(JSON.stringify(message));
                } else {
                    // Others
                    win.console.log(message);
                    // this.triggerFail(message.callbackId, "ERR_SDKCommand_EXEC", null);
                }*/
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
    }());

    if (!window.flutterApp) {
        window.flutterApp = new Command(window.flutterApp);
    }

    return Command;
}());
