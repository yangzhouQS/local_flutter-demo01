import {defineComponent, onMounted, ref} from "vue"

export const CmpNavigation = defineComponent({
	name: 'cmp-navigation',
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
					navigation 导航操作
				</div>
			)
		}
	}
})
