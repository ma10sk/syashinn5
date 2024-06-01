class PhotosController < ApplicationController
    
    before_action :authenticate_user!, only: [:index, :new, :create, :show, :edit, :update, :destroy, :search, :top]

      def index
        @user = current_user
        @tag_list = Tag.all.sort { |a, b| b.photos.count <=> a.photos.count }
        
        if params[:search].present?
          search = params[:search]
          @photos = @user.photos.joins(:tags)
                                .where("photos.image_top LIKE ? OR tags.tag_name LIKE ?", "%#{search}%", "%#{search}%")
        else
          @photos = @user.photos
        end
      end

      def new
        #@photo = Photo.new
        @photo = current_user.photos.new
      end

      def create
        @photo = current_user.photos.new(photo_params)
        #tag_name = params[:photo][:tag_name] || ''  # nilの場合は空文字列を代入
        #tag_list = tag_name.split(nil)
        @photo.tag_name = params[:photo][:tag_name]
        
        if @photo.save
          #@photo.save_tag(tag_list)
          @photo.save_tag(@photo.tag_name.split)
          redirect_to photos_path
        else
          #redirect_to new_photo_path
          render :new
        end
      end

      def show
        @photo = Photo.find(params[:id])
        @photo_tags = @photo.tags
      end

      def edit
        @photo = Photo.find(params[:id])
        #@tag_list=@photo.tags.pluck(:tag_name).join(nil)
        @photo.tag_name = @photo.tags.pluck(:tag_name).join(' ')
      end

      def update
        #photo = Photo.find(params[:id])
        #tag_name = params[:photo][:tag_name] || ''  # nilの場合は空文字列を代入
        #tag_list = tag_name.split(nil)
        @photo = Photo.find(params[:id])
        @photo.tag_name = params[:photo][:tag_name]
        
        #if photo.update(photo_params)
          #old_relations = TagMap.where(photo_id: photo.id)
          #old_relations.each(&:delete)
          #photo.save_tag(tag_list)
          #redirect_to photo_path(photo.id), notice: '投稿完了しました:)'
        if @photo.update(photo_params)
          old_relations = TagMap.where(photo_id: @photo.id)
          old_relations.each(&:delete)
          @photo.save_tag(@photo.tag_name.split)
          redirect_to @photo, notice: '投稿完了しました:)'
        else
          #redirect_to :action => "edit"
          render :edit
        end
      end

      def destroy
        #photo = Photo.find(params[:id])
        #photo.destroy
        #redirect_to action: :index
        @photo = Photo.find(params[:id])
        @photo.destroy
        redirect_to photos_path, status: :see_other
      end

      def search
        @tag_list = Tag.all.sort {|a,b| b.photos.count <=> a.photos.count} 
        @tag = Tag.find(params[:tag_id])
        @photos = @tag.photos.all
      end

      def top
        #if params[:search] != nil && params[:search] != ''
        if params[:search].present?
           search = params[:search]
          @tag_list = Tag.where("tag_name LIKE ?", "%#{search}%")
        else
          @tag_list = Tag.all.sort { |a, b| b.photos.count <=> a.photos.count }
        end
      end
    
  private

  def photo_params
    #params.require(:photo).permit(:image, :image_top , images: [])
    params.require(:photo).permit(:image, :tag_name, :image_top , images: [])
  end


end
