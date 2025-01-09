import {defineComponent, onMounted, ref} from "vue"

export const CmpClipboardData = defineComponent({
	name: 'CmpClipboardData',
	props: {
		title: {
			type: String,
			default: ''
		}
	},
	setup() {
		// data
		const data = ref({})

		// methods
		const methods = {
			setClipboardData: () => {
				flutterApp.setClipboardData({
					text: "设置剪切板内容" + new Date().toLocaleString(),
					success: function (res) {
						console.log('回调结果: res setClipboardData', res)

						Object.assign(data.value, {
							action:"设置剪切板",
							res
						})
					},
					fail: function (error) {
						console.log("error", error)
					}
				})
			},
			getClipboardData: () => {
				flutterApp.getClipboardData({
					success: function (res) {
						console.log('回调结果: res getClipboardData', res)
						Object.assign(data.value, {
							action:'获取剪切板内容',
							res
						})
					},
					fail: function (error) {
						console.log("error", error)
					}
				})
			},
		}

		onMounted(() => {

		})

		return () => {
			return (
				<div class={'full-container'}>
					<nut-space direction="vertical" fill>
						<nut-button block onClick={methods.setClipboardData}>设置剪切板内容</nut-button>
						<nut-button block onClick={methods.getClipboardData}>获取剪切板内容</nut-button>
						<pre>
							{JSON.stringify(data.value, null, 2)}
						</pre>
					</nut-space>
				</div>
			)
		}
	}
})
