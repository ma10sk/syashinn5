class UsersController < ApplicationController

    before_action :authenticate_user!, only: [:show]
    skip_before_action :authenticate_user!, only: [:top]


    def show
        @user = User.find(params[:id]) 
        @photos = @user.photos.all # 追記
    end

    def top
        
    end
end
