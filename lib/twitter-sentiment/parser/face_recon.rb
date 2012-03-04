require 'twitter-sentiment/input/face_recon.rb'
require 'purdy-print'

module TwitterSentiment
  module Parser
    include PurdyPrint
    class FaceRecon

      def initialize
        @client = TwitterSentiment::Input::FaceRecon.new
        pp :info, "Face parser initialized successfully."
      end
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      # Returns an array of arrays (info about the detected faces)
      #
      # @param [FaceAPI search] Image info
      # @return [[boolean,int]...] Smiling?, confidence
      def smile_info info = ""
        info = info["photos"][0]["tags"]
        arr = []
        info.each do |n|
          n = n["attributes"]["smiling"]
          arr << [n["value"],n["confidence"]]
        end
        arr
      end

      #Finds the average happiness of people in profile picture, 
      #weighted based on confience and number of faces
      #@param [String] imgURL
      #@return [float] average happiness
      def profile_image_happiness img = nil
        if img != nil
          if img.index("_normal") != nil #to feed the face API larger images
            len = img.length
            img = img[0..len - 12] + img[len - 4..len - 1] #remove "_normal"
          end
          arr = @client.detect_faces(img) #call whatever calls the FaceAPI
          arr = smile_info(arr) #format the search results
          return 0 if arr.length == 0
          # expecting arr = [[boolean,int],[boolean,int].....]
          score = 0
          arr.each do |n|
            s = n[1]
            s *= -1 if !n[0]
            score += s
          end
          score.to_f / arr.length.to_f
        end # if != nil
      end
    end # FaceRecon
  end # Parser
end # TwitterSentiment
