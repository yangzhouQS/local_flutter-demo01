import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'
import pluginCssInjectedByJs from "vite-plugin-css-injected-by-js";
import pluginVueJsx from '@vitejs/plugin-vue-jsx'
import path from 'path'
import { viteSingleFile } from "vite-plugin-singlefile"


// https://vite.dev/config/
export default defineConfig({
	plugins: [
		vue(),
		// pluginCssInjectedByJs(),
		pluginVueJsx(),
		viteSingleFile(),
	],
	resolve: {
		extensions: ['.js', '.jsx', '.ts', '.tsx', '.vue'],
	},
	define: {
		'process.env': {},
		"process.platform": {},
		// 'process.env.NODE_ENV': 'production'
	},
	css:{
	},
	build:{
		emptyOutDir: false,
		minify: false,
		cssCodeSplit: false,
		copyPublicDir: false,
		outDir: path.resolve(__dirname,'..','web-dist'),
		/*rollupOptions:{
			output:{
				entryFileNames: `assets/[name].js`,
				// inlineDynamicImports: true,
				// dummy: true,
				manualChunks: {}
			}
		}*/
	},
	server: {
		// host: "yang-flutter.com",
		port: 3800
	}
})
