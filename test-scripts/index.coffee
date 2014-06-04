restler = require 'restler'
assert = require 'assert'

describe "Test", ->
  describe "encode()", ->
    it "should convert an mp4 file to ogg without error", (done) ->
      restler.get "https://raw.githubusercontent.com/pericles-project/mock-workflow-server/master/workflows.json"
      .on "complete", (result) =>
        throw new Error result.message if result instanceof Error
        result = JSON.parse result

        wf = result[0]
        componentConfig = wf.wf[0]

        console.info "Trying to call component #{componentConfig.id} at #{componentConfig.url}..."
        restler.post "#{componentConfig.url}", 
          payload:
            xid: "1"
            xuri: "https://github.com/pericles-project/tests.git"
            wid: "#{wf.id}/0"
          params: componentConfig.params
        .on "complete", (result) =>
          throw new Error result.message if result instanceof Error
          result = JSON.parse result

          throw new Error "Call to component #{componentConfig.id} at #{componentConfig.url} did not return a wiid." if not result.wiid?

          assert.equal 'object', typeof result
          assert.equal 'string', typeof result.wiid

          currentState = ''

          interval = setInterval ->
            console.info "Trying to get status from component #{componentConfig.id} at #{componentConfig.url}..."
            restler.get "#{componentConfig.url}/status/#{result.payload.wiid}/#{result.payload.wstep}", (result) => 
              throw new Error result.message if result instanceof Error
              result = JSON.parse result

              throw new Error "Call to component #{componentConfig.id} at #{componentConfig}/status/#{result.wiid} did not return a state." if not result.state?
              
              currentState = result.state

              assert.equal 'object', typeof result
              assert.equal 'string', typeof result.state

              if result.state is 'COMPLETED'
                done()
              else if result.state is 'FAILED'
                throw new Error "Component #{componentConfig.id} failed at #{wf.id}/0." if result instanceof Error
          , 5 * 1000

          setTimeout ->
            if currentState is 'PENDING'
              throw new Error "Component #{componentConfig.id} seems to have a problem at #{wf.id}/0." if result instanceof Error
              clearInterval interval
          , 30 * 1000
