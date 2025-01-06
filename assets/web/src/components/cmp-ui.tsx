import {defineComponent, onMounted, ref} from "vue"

export const CmpUi = defineComponent({
	name: 'cmp-ui',
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
			loadData: () => {
				flutterApp.getNavigationBarConfig({
					success: function (res) {
						console.log('回调结果: res getNavigationBarConfig')
						console.log(res)
						Object.assign(data.value,res)
					},
					fail: function (error) {
						console.log("error", error)
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
						<nut-button onClick={methods.loadData}>获取barConfig</nut-button>
						<pre>
							{JSON.stringify(data.value,null,2)}
						</pre>
					</nut-space>
				</div>
			)
		}
	}
})
