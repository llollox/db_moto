module TaskUtilities 
  require 'nokogiri'
  require 'open-uri'
  require 'timeout'

  def brandModelCoded name

    brandModelCoded = I18n.transliterate(name.strip)
      .gsub(/\s\s/,'-')
      .gsub('(','-')
        .gsub(')','')
        .gsub('/','-')
        .gsub(' & ','--')
        .gsub('&','-')
        .gsub(' e ','-')
        .gsub(' E ','-')
        .gsub('@ ','')
        .gsub('\'\'','-')
        .gsub('\'','-')
        .gsub(' - ','-')
        .gsub(/\s/,'-')
        .gsub('.','')
        .gsub(',','')
        .downcase.to_s

    if brandModelCoded[brandModelCoded.size-1] == '-'
      brandModelCoded[brandModelCoded.size-1] == ''
    end

    return brandModelCoded
  end

  def checkEmptyString string
    if string == ""
      return nil
    else
      return string
    end
  end

  def convertRelativeUrl url
      if url[0] == "/" #url relativo
        return "http://www.moto.it" + url
      else
        return url
      end
    end

  def openUrl url
    result = nil
    begin
      retryable(:tries => 10, :on => Timeout::Error) do
        result = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))
      end
    rescue SocketError => se
      puts "Got Socket error: #{se}"
    rescue OpenURI::HTTPError => he
      puts "Got HTTP Error: #{he}"
    end

    return result
  end

  def getPicture url
    begin
      retryable(:tries => 10, :on => Timeout::Error) do
        return open(url)
      end
    rescue OpenURI::HTTPError => ex
      puts "No picture for found!"
    end 
  end

  def retryable(options = {})
      opts = { :tries => 1, :on => Exception }.merge(options)

      retry_exception, retries = opts[:on], opts[:tries]

      begin
        return yield
      rescue retry_exception
        if (retries -= 1) > 0
          sleep 2
          retry 
        else
          raise
        end
      end
    end


end