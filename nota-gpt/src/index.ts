import { handle } from "./router"

declare global {
  const OPENAI_TOKEN: string
}

addEventListener('fetch', (event) => {
  event.respondWith(
    handle(event.request)
  )
})