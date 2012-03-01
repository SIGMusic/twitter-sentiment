require 'twitter-sentiment/parser/face_recon'

module TwitterSentiment
  module Parser
    class UserInfo
    	#@param [Twitter::User] the user in question
    	#@return data about the user
    	def gather user
    		#Call all of the included methods
    		boringImages = defaultImgs(user.profile_background_image_url, user.profile_image_url) #int
    		followPerTweet = user.followers_count.to_f / user.statuses_count.to_f #float
    		profHappiness = FaceRecon.profileImageHappiness(user.profile_image_url) #float
    		
    		#Spit out data in some format
    	end

    	#@param [String] Image url of user background image
    	#@param [String] Image url of user profile image
    	#@return [int] number of images that are default
    	def defaultImgs back = nil, prof = nil
    		r = 0
    		r += 1 if back.index("twimg.com/images/themes/") != nil
    		r += 1 if prof.index("twimg.com/sticky/default_profile_images/") != nil
    		return r
    	end
    end #UserInfo
  end #Parser
end #TwitterSentiment