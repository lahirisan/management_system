#encoding: UTF-8
class ProductosDatatable
  delegate :params, :h, :link_to, :content_tag, to: :@view

   def initialize(view)
    
    @view = view
   end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: productos.count,
      iTotalDisplayRecords: productos.total_entries,      
      aaData: data
    }

  end

private

  def data

    productos.map do |producto|
      
      if params[:empresa_retirada] == 'true'
        
        boton_gtin_14 = ""
        boton_editar = ""
      
      elsif params[:insolvente] == 'true'
        
        
        if (UsuariosAlcance.verificar_alcance(params[:perfil], params[:gerencia], 'Generar Código'))
          boton_gtin_14 = link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+"GTIN14").html_safe, "/empresas/#{params[:empresa_id]}/productos/new?gtin=#{producto.gtin}&base=#{base}&descripcion=#{producto.descripcion}&marca=#{producto.marca.gsub(/‘/, '%27')}&gpc=#{producto.gpc}",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Generar GTIN-14"})
        else
          boton_gtin_14 = ""
        end
          
        boton_editar = ""

      else # Empresa ACTIVA
       

        if UsuariosAlcance.verificar_alcance(params[:perfil], params[:gerencia], 'Registrar Producto')
          
          if (producto.id_tipo_gtin == 1) or (producto.id_tipo_gtin == 3) ## Solo se muestra el boton Generar GTIN14 si el producto es tipoGTIN 8 o tipoGTIN13
            base = (producto.id_tipo_gtin == 1) ? 4 : 6  # Para mostrar seleccioando la base del producto cunado se crear GTIN 14
            
            ################### ESTOS CARACTERES SE CAMBIAN POR QUE GENERAR BAD URI EXCEPTION #################

            descripcion_codificada = producto.descripcion.gsub(/%/, '')
            marca_codificada = producto.marca.gsub(/%/, '')
            boton_gtin_14 = link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+"GTIN14").html_safe, "/empresas/#{params[:empresa_id]}/productos/new?gtin=#{producto.gtin}&base=#{base}&descripcion=#{descripcion_codificada}&marca=#{marca_codificada}&gpc=#{producto.gpc}&generar_gtin_14=true",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Generar GTIN-14"})
          
          end

          

        else
          boton_gtin_14 = ""
        end

        if UsuariosAlcance.verificar_alcance(params[:perfil], params[:gerencia], 'Modificar Producto')
          boton_editar = link_to(( content_tag(:span, '',:class => 'ui-icon ui-icon-extlink')+"Editar").html_safe, "/empresas/#{params[:empresa_id]}/productos/#{producto.gtin}/edit",{:class => "ui-state-default ui-corner-all botones_servicio", :title => "Editar Producto"})
        else
          boton_editar = ""
        end

      end

      fecha = ""
      fecha =  producto.fecha_creacion.strftime("%Y-%m-%d") if (producto.fecha_creacion)
      fecha_modificacion = ""
      fecha_modificacion =  producto.fecha_ultima_modificacion.strftime("%Y-%m-%d") if (producto.fecha_ultima_modificacion)
      
      [ 
       producto.try(:tipo_gtin).try(:tipo),
       producto.gtin,
       producto.descripcion,
       producto.marca,
       producto.try(:estatus).try(:descripcion),
       producto.codigo_prod,
       fecha,
       fecha_modificacion,
       boton_gtin_14,
       boton_editar
      ]

    end

  end

  def productos

    productos ||= fetch_productos
  end

  def fetch_productos
    
    productos = Producto.where("prefijo = ?", params[:empresa_id]).includes(:estatus, :tipo_gtin).order("#{sort_column} #{sort_direction}") 
    
    productos = productos.page(page).per_page(per_page)


    if params[:sSearch].present? # Filtro de busqueda general
      productos = productos.where("tipo_gtin.tipo like :search or producto.gtin like :search or producto.descripcion like :search or producto.marca like :search or estatus.descripcion like :search or estatus.descripcion like :search or producto.codigo_prod like :search or producto.fecha_creacion like :search", search: "%#{params[:sSearch]}%")
    end
    
    
    if params[:sSearch_0].present? # Filtro de busqueda por Tipo GTIN
      productos = productos.where("tipo_gtin.tipo like :search0", search0: "%#{params[:sSearch_0]}%" )
    end

    if params[:sSearch_1].present? # Filtro GTIN
      productos = productos.where("producto.gtin like :search1", search1: "%#{params[:sSearch_1]}%" )
    end
    
    if params[:sSearch_2].present?
      productos = productos.where("producto.descripcion like :search2", search2: "%#{params[:sSearch_2]}%" )
    end

    if params[:sSearch_3].present?
      productos = productos.where("producto.marca like :search3", search3: "%#{params[:sSearch_3]}%" )
    end

    if params[:sSearch_5].present?
      productos = productos.where("producto.codigo_prod like :search5", search5: "%#{params[:sSearch_5]}%" )
    end

    if params[:sSearch_6].present?
      
      productos = productos.where("CONVERT(varchar(255),  producto.fecha_creacion ,126) like :search6", search6: "%#{params[:sSearch_6]}%")
      
    end

    if params[:sSearch_7].present?
      
      productos = productos.where("CONVERT(varchar(255),  producto.fecha_ultima_modificacion ,126) like :search7", search7: "%#{params[:sSearch_7]}%")
      
    end



    productos
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page


    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 100
  end

  def sort_column

     columns = %w[tipo_gtin.tipo producto.gtin producto.descripcion producto.marca estatus.descripcion producto.codigo_prod producto.fecha_creacion producto.fecha_ultima_modificacion nil nil]
     columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  
end