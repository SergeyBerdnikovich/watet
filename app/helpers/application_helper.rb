module ApplicationHelper
  def get_avatar
    session[:soc_ava].blank? ? image_tag('/assets/maket/no_avatar.png') : image_tag(session[:soc_ava])
  end
	def show_page(name)
		page = StaticPage.find_by_name(name)
		page ? text = page.content : page = StaticPage.create!(:name => name)
		text.blank? ? text = "<p>There is no text available. If you are admin, please add it #{ link_to 'here', edit_admin_static_page_path(page) }.</p>" : text
	end
	def link_to_page(name)
		page = StaticPage.find_by_name(name)
		page = StaticPage.create!(:name => name) unless page
		static_page_path(page)
	end
end
