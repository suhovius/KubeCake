ActiveAdmin.register Github::Repository do
  menu label: 'Repositories',
       parent: 'Github',
       priority: 1

  actions :index, :show
end
