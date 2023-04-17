import { handle } from '../src/router'
import makeServiceWorkerEnv from 'service-worker-mock'

declare var global: any

describe('handle', () => {
  beforeEach(() => {
    Object.assign(global, makeServiceWorkerEnv())
    jest.resetModules()
  })

  test('handle GET', async () => {
    const request = new Request('/', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${btoa("Elva")}`
      }
    })
    const result = await handle(request)
    expect(result.status).toEqual(200)
    const text = await result.text()
    expect(text).toEqual('request method: GET')
  })
})
