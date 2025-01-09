import {defineComponent, onMounted, ref} from "vue"

export const CmpPlatformInfo = defineComponent({
	name: 'cmp-platform-info',
	props: {
		title: {
			type: String,
			default: ''
		}
	},
	setup() {
		// data
		const menuConfig = ref([])
		const info = ref({
			brand:'',
			id:'',
			host:'',
			display:"", // 用于向用户显示的构建ID字符串
			bootloader:"", // 系统引导程序的版本号
			fingerprint:"", // 唯一标识此构建的字符串
			hardware:"", // 硬件的名称（来自内核命令行或/proc）
			manufacturer:"", // 产品/硬件的制造商
			model:"", // 最终产品的最终用户可见名称
			product:"", // 整体产品的名称
			serialNumber:"", // 设备的硬件序列号（如果可用）
			tags:"", // 描述构建的逗号分隔的标签，如 “unsigned,debug”
			type:"", // 构建的类型，如 “user” 或 “eng”
		})

		// methods
		const methods = {
			handleClick: () => {
				console.log(Object.keys(flutterApp))
				console.log(flutterApp.getSystemInfo)

				flutterApp.getSystemInfo({
					success: function (res) {
						console.log('回调结果: res getSystemInfo')
						console.log(res)
						const obj = {} as Record<string, any>;
						 Object.keys(info.value).forEach(key=>{
							obj[key] = res[key];
						})
						Object.assign(info.value,obj);
					},
					fail: function (error) {
						console.log("getSystemInfo error", error)
					}
				})
			}
		}

		onMounted(() => {

		})

		return () => {
			return (
				<div class={'full-container'}>
					<nut-space direction="vertical" fill>
						<nut-button onClick={methods.handleClick}>获取设备信息</nut-button>

						<pre>
							{JSON.stringify(info.value,null,2)}
						</pre>
					</nut-space>
				</div>
			)
		}
	}
})
