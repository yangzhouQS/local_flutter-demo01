import {defineComponent, onMounted, ref} from "vue"

export const CmpShare = defineComponent({
	name: 'cmp-share',
	props: {
		title: {
			type: String,
			default: ''
		}
	},
	setup() {
		// data
		const menuConfig = ref([])

		// methods
		const methods = {
			loadData: () => {

			}
		}

		onMounted(() => {

		})

		return () => {
			return (
				<div class={'full-container'}>
					xxx 第三方分享
				</div>
			)
		}
	}
})
