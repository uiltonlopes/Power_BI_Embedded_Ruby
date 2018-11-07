class GenerateToken

    require "net/http"
    require "uri"

    def getAccessToken
    
        client_id = 'CLIENT_ID'
        username = 'YOUR_USER_NAME'
        password = 'YOUR_PASSWORD'
        
        uri = URI.parse("https://login.microsoftonline.com/common/oauth2/token")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = 'application/x-www-form-urlencoded'
        request.set_form_data({
            "grant_type": "password",
            "scope": "openid",
            "resource": "https://analysis.windows.net/powerbi/api",
            "client_id": client_id, 
            "username": username, 
            "password": password
        })
        response = http.request(request)
        data = JSON.parse response.body
        
        data['access_token']
    end

    def getEmbeddToken(groupid, reportid)
    
        token = getAccessToken
        
        uri = URI.parse("https://api.powerbi.com/v1.0/myorg/groups/#{groupid}/reports/#{reportid}/GenerateToken")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Authorization"] = "Bearer #{token}"
        request["Content-Type"] = 'application/json'
        request.set_form_data({"accessLevel": "View", "allowSaveAs": "false"})
        response = http.request(request)
        data = JSON.parse response.body
        
        data['token'] 
    end
end
