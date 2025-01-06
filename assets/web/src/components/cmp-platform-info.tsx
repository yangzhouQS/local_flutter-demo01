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
			model:'',
			id:'',
			host:'',
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
