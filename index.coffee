fs = require 'fs'
$ = require 'jquery'
restler = require 'restler'

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

          console.info result

          setInterval ->
            console.info 'Trying to get status from component #{componentConfig.id} at #{componentConfig.url}...'
            restler.get "#{componentConfig.url}/{#{wf.id}/0}", (result) => 
              throw new Error result.message if result instanceof Error
              result = JSON.parse result

              if result.statusCode is '200'
                done()
          , 5000


          done()
