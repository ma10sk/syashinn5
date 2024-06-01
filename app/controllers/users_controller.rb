class UsersController < ApplicationController
    def show
        @user = User.find(params[:id]) 
        @photos = @user.photos.all # 追記
    end
end
