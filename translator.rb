#Made with Microsft API translator
require 'net/https'
require 'uri'
require 'json'
require 'securerandom'

class Translator
   def initialize
    @subscription_key = 'Your_key_subscription'

    @subscription_region = 'your_region_subscription'

    @endpoint = 'https://api.cognitive.microsofttranslator.com/'

    @path = '/translate?api-version=3.0'

    puts 'Escolha a lingua a ser original[pt-br,en,de,it...]:'
    from = gets.chomp
    @original_language = "&from=#{from}"

    puts 'Escolha a lingua traduzida:[pt-br,en,de,it...]'
    to = gets.chomp
    @params = "&to=#{to}"

    puts'Digite seu texto'
    @text = gets.chomp

    json_translated = translate
    original = "#{@text}"
    write(original, json_translated)
   end

    def translate
        content = '[{"Text" : "' + @text + '"}]'
        return send_post(content)
    end
    private
    def send_post(content)
        uri = URI(@endpoint + @path + @params + @original_language)
        request = Net::HTTP::Post.new(uri)
        request ['Content-type'] = 'application/json'
        request ['Content-length'] = content.length
        request ['Ocp-Apim-Subscription-Key'] = @subscription_key
        request ['Ocp-Apim-Subscription-Region'] = @subscription_region
        request ['X-ClientTraceId'] = SecureRandom.uuid
        request.body = content

        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
            http.request (request)
        end
            
        result = response.body.force_encoding("utf-8")
            
        json = JSON.pretty_generate(JSON.parse(result))
        json = JSON.parse(result)[0]['translations'][0]['text']  
        return json
    end

    def write(original, json_translated)
    time = Time.new
    file_name = time.strftime('%d-%m-%y_%H:%M') + '.txt'
    File.open(file_name, 'w') do |line|
        line.print('Texto original: ')
        line.puts''
        line.puts(original)
        line.print('Texto traduzido: ')
        line.puts(json_translated)
        end
    end
end
Translator.new


