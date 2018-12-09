class Admin::SettingsController < Admin::Base

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    @admin.assign_attributes(setting_params)
    if @admin.save
      redirect_to admin_problems_path, notice: 'アカウントを更新しました。'
    else
      render 'edit'
    end
  end

  private

  def setting_params
    attrs = [:name, :password]
    params.require(:admin).permit(attrs)
  end
end
