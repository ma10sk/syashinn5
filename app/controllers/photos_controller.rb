class PhotosController < ApplicationController
    
    before_action :authenticate_user!, only: [:index, :new, :create, :show, :edit, :update, :destroy, :destroy_tag, :search, :top]

      def index
        @user = current_user
        if params[:search].present?
          search = params[:search]
          @photos = @user.photos.joins(:tags).where("image LIKE ? OR tag_name LIKE ?", "%#{search}%", "%#{search}%")
        else
          @photos = @user.photos
        end
      end

      def new
        @photo = current_user.photos.new
      end


      def create # 追記
        @photo = current_user.photos.new(photo_params)
        tag_name = params[:photo][:tag_name] || '' #
        @photo.tag_name = tag_name #
        
        if @photo.save
          @photo.save_tag(tag_name.split) #
          redirect_to photos_path
        else
          render :new
        end
     end


      def show
        @photo = Photo.find(params[:id])
        @photo_tags = @photo.tags
      end

      def edit #
        @photo = Photo.find(params[:id])
        @tag_list = @photo.tags.pluck(:tag_name).join(' ') # スペースで区切られたタグ名のリスト
        @photo.tag_name = @tag_list
      end
      
      def update # 追記
        @photo = Photo.find(params[:id])
        tag_name = params[:photo][:tag_name] || '' #
        @photo.tag_name = tag_name #
        
        if @photo.update(photo_params)
          old_relations = TagMap.where(photo_id: @photo.id)
          old_relations.each(&:delete)
          @photo.save_tag(tag_name.split)
          redirect_to @photo, notice: '投稿完了しました:)'
        else
          render :edit
        end
      end


      def destroy
        @photo = Photo.find(params[:id])
        @photo.destroy
        redirect_to photos_path, status: :see_other
      end

      def destroy_tag
        @tag = Tag.find(params[:tag_id])
        @tag.destroy
        redirect_to photos_top_path, status: :see_other
      end


      def search # 追記
        @user = current_user
        @tag_list = @user.tags.all.sort { |a, b| b.photos.count <=> a.photos.count }
        @tag = @user.tags.find(params[:tag_id]) #
        @photos = @tag.photos.all
      end


      def top # 追記
        @user = current_user
        if params[:search].present?
           search = params[:search]
           @tag_list = @user.tags.where("tag_name LIKE ?", "%#{search}%") #
        else
           @tag_list = @user.tags.all.sort { |a, b| b.photos.count <=> a.photos.count }
        end
      end
    

  private

  def photo_params
    params.require(:photo).permit(:image, :tag_name, :image_top , images: [])
  end


end
