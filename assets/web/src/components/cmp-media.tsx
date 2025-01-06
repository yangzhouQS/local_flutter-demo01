import {defineComponent, onMounted, ref} from "vue"

export const CmpMedia = defineComponent({
	name: 'cmp-media',
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
					media 媒体文件操作
				</div>
			)
		}
	}
})
