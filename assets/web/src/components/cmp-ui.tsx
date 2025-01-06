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
						Object.assign(data.value, res)
					},
					fail: function (error) {
						console.log("error", error)
					}
				})
			},
			showToast: () => {
				flutterApp.showToast({
					text: "我就是我的提示",
					success: function (res) {
						console.log('回调结果: res showToast')
					},
					fail: function (error) {
						console.log("error", error)
					}
				})
			},
			showModal: () => {
				flutterApp.showModal({
					title: "处理成功啦",
					content: "告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。",
					cancelText: "取消",
					confirmText: "确定",
					success: function (res) {
						console.log('回调结果: res showToast')
					},
					fail: function (error) {
						console.log("error", error)
					}
				})
			},
			showModal2: () => {
				flutterApp.showModal({
					title: "处理成功啦",
					content: "告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。",
					cancelText: "取消",
					confirmText: "确定",
					// 带确认的弹出框
					type: 'alert',
					success: function (res) {
						console.log('回调结果: res showToast')
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
						<nut-button block onClick={methods.showModal}>弹出框</nut-button>
						<nut-button block onClick={methods.showModal2}>弹出确认框</nut-button>
						<nut-button block onClick={methods.showToast}>showToast</nut-button>
						<nut-button block onClick={methods.loadData}>获取barConfig</nut-button>
						<pre>
							{JSON.stringify(data.value, null, 2)}
						</pre>
					</nut-space>
				</div>
			)
		}
	}
})
