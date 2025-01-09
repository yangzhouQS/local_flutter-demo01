import {defineComponent, onMounted, ref} from "vue"

export const CmpScannerCode = defineComponent({
	name: 'CmpScannerCode',
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
			scanCode: () => {
				flutterApp.scanCode({
					success: function (res) {
						console.log('识别回调结果: res scanCode', res)
						Object.assign(data.value, res)
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
						<nut-button block onClick={methods.scanCode}>识别二维码</nut-button>
						<pre>
							{JSON.stringify(data.value, null, 2)}
						</pre>
					</nut-space>
				</div>
			)
		}
	}
})
