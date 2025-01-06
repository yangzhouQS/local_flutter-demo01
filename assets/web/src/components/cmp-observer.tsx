import {defineComponent, onMounted, ref} from "vue"

export const CmpObserver = defineComponent({
	name: 'cmp-observer',
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
					监听
				</div>
			)
		}
	}
})
