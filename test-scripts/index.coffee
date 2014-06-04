restler = require 'restler'
assert = require 'assert'

PLANK_HOST = process.env.PLANK_HOST or "localhost"
PLANK_PORT = process.env.PLANK_PORT or 7000

WFS_HOST = process.env.WFS_HOST or "localhost"
WFS_PORT = process.env.WFS_PORT or 8000

describe "Test", ->
  describe "encode()", ->
    it "should convert an mp4 file to ogg without error", (done) ->
      @timeout 30 * 1000

      restler.json "http://#{WFS_HOST}:#{WFS_PORT}/workflows/1"
      .on "complete", (result) =>
        throw new Error result.message if result instanceof Error

        wf = result
        componentConfig = wf.wf[0]

        # console.info "Trying to call component #{componentConfig.id} at #{componentConfig.url}..."
        restler.postJson "#{componentConfig.url}", 
          payload:
            xid: "1"
            xuri: "https://github.com/pericles-project/tests.git"
            wid: "#{wf.id}/0"
          params: componentConfig.params
        .on "complete", (result, response) =>
          throw new Error result.message if result instanceof Error
          throw new Error "Call to component #{componentConfig.id} at #{componentConfig.url} did not return a wiid." if not result.payload?.wiid?

          assert.equal 'object', typeof result
          assert.equal 'string', typeof result.payload.wiid

          interval = setInterval ->
            # console.info "Trying to get status from component #{componentConfig.id} at #{componentConfig.url}..."
            restler.json "http://#{PLANK_HOST}:#{PLANK_PORT}/status/#{result.payload.wiid}/#{result.payload.wstep}"
            .on "complete", (result) => 
              throw new Error result.message if result instanceof Error
              throw new Error "Call to component #{componentConfig.id} at #{componentConfig}/status/#{result.payload.wiid} did not return a state." if not result.state?

              assert.equal 'object', typeof result
              assert.equal 'string', typeof result.state

              if result.state is 'COMPLETED'
                done()
              else if result.state isnt 'PENDING' and result.state isnt 'WORKING'
                throw new Error "Component #{componentConfig.id} failed at #{wf.id}/0 with #{result.error.message}"
          , 5 * 1000
