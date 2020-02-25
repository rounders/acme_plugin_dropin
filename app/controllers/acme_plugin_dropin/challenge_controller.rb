module AcmePluginDropin
  class ChallengeControlller < ApplicationController
    def index
      if params[:challenge].present? && params[:challenge].length >= 16 && params[:challenge].length <= 256
        render plain: LetsEncrypt.current_challenge, status: :ok
      else
        render plain: "Challenge failed", status: :bad_request
      end
    end
  end
end
