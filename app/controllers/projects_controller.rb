class ProjectsController < ApplicationController
  
  def new
    @project = Project.new
    @categories = [
      ["Kuhinja"],
      ["Kopalnica"],
      ["Spalnica"],
      ["Dnevni prostor"],
      ["Jedilnica"],
      ["Otroški prostor"],
      ["Delovni prostor"],
      ["Utility & shramba"],
      ["Vhod & garderoba"],
      ["Hodnik"],
      ["Stopnišče"],
      ["Klet"],
      ["Garaža"],
      ["Hiša & fasade"],
      ["Okolica"],
      ["Svetila"],
      ["Hobi & dekor"]
    ]
  end

  def create
    @project = Project.new(project_params)
    @user = current_user
      if @project.save
        auto_create_user!(@project)
        # if params[:images]
        #   #===== The magic is here ;)
        #   params[:images].each { |image|
        #     @project.pictures.create(image: image)
        #   }
        # end
      redirect_to user_path(@user)
      else 
      redirect_to new_project_path
      end
  end 

  def edit
    @project = Project.find(params[:id])
    @categories = [
      ["Kuhinja"],
      ["Kopalnica"],
      ["Spalnica"],
      ["Dnevni prostor"],
      ["Jedilnica"],
      ["Otroški prostor"],
      ["Delovni prostor"],
      ["Prostor za shranjevanje"],
      ["Vhod in garderoba"],
      ["Hodnik"],
      ["Stopnišče"],
      ["Klet"],
      ["Garaža in hobi prostor"],
      ["Hiša in fasade"],
      ["Okolica"],
      ["Svetila"],
      ["Dekor"]
    ]
  end

  def update
      @project = Project.find(params[:id])
      @user = current_user
      @categories = [
      ["Kuhinja"],
      ["Kopalnica"],
      ["Spalnica"],
      ["Dnevni prostor"],
      ["Jedilnica"],
      ["Otroški prostor"],
      ["Delovni prostor"],
      ["Prostor za shranjevanje"],
      ["Vhod in garderoba"],
      ["Hodnik"],
      ["Stopnišče"],
      ["Klet"],
      ["Garaža in hobi prostor"],
      ["Hiša in fasade"],
      ["Okolica"],
      ["Svetila"],
      ["Dekor"]
    ]
    if @project.update_attributes(project_params)
      redirect_to user_path(@user)
    else 
      redirect_to edit_project_path
    end
    @project.save
  end



  def index
    @projects = Project.all
    @sorted_projects = @projects.sort.reverse
    @likes = Like.all
    @projects.each do |project|
      @project = project
    end
    @filter_1_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-1'}").count
    @filter_2_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-2'}").count
    @filter_3_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-3'}").count
    @filter_4_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-4'}").count
    @filter_5_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-5'}").count
    @filter_6_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-6'}").count
    @filter_7_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-7'}").count
    @filter_8_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-8'}").count
    @filter_9_count   = Project.all.where(category: "#{I18n.t'project-index.data-filter-9'}").count
    @filter_10_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-10'}").count
    @filter_11_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-11'}").count
    @filter_12_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-12'}").count
    @filter_13_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-13'}").count   
    @filter_14_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-14'}").count
    @filter_15_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-15'}").count
    @filter_16_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-16'}").count
    @filter_17_count  = Project.all.where(category: "#{I18n.t'project-index.data-filter-17'}").count
  end

  def show
    @project = Project.find_by_id(params[:id])
    if @project.present?
      @project_title = @project.title 
      @project_description = @project.description
      @project_email = @project.email
    end
  end


  def destroy
     @project = Project.find_by_id(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(
      :title,
      :de_title, 
      :user_id,
      :picture,
      :email,
      :description,
      :de_description,
      :category
    )
  end

  def auto_create_user!(project)
    if user_signed_in?
      project.user_id = current_user.id
    else
      user = User.find_by_email(project.email)
      if user
        project.user_id = user.id
      else
        pass = SecureRandom.hex[0..7]
        user = User.create!(
                 email: project.email, 
                 password: pass, 
                 password_confirmation: pass
               )
        project.user_id = user.id
        user.projects << project
        UserMailer.welcome_email(user, pass).deliver
        beta = user
        if user.country == "Slovenia"
          User.find_by_id(1).send_message(beta, "Pozdravljeni, vsakič ko se bo nekdo zanimal za vaš projekt oz. sodelovanje z vami, vas bomo obvestili. Vsa prejeta in poslana sporočila najdete med Vašimi sporočili.", "Kako pošiljate in sprejemate sporočila.")
        else 
          User.find_by_id(1).send_message(beta, "Hi, this is Nina from ZweiDesign. Just wanted to tell you, that each time someone will send you a message, we will notify you via your email. We encourage you to get in touch with other providers and get to know them. You can send a message throught user's projects or their profile pages.", "ZweiDesign Messages.")
        end
      end
    end
    project.save
  end
end