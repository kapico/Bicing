use model_bicing;
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

select * from alquiler;
select * from bicicleta;
select * from facturacion;
select * from usuario;
select * from cuenta;
select * from tarjetas;

update bicicleta set estado = 0;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1) Crear un trigger que elimine la tarjeta asociada a un usuario en cuanto se elimine su cuenta:
	
    drop trigger if exists borrar_usuario;
	delimiter //
	CREATE TRIGGER borrar_usuario AFTER DELETE ON cuenta
		FOR EACH ROW 
		BEGIN
			DELETE FROM usuario WHERE dni = OLD.usuario_dni;
	end // 

	delimiter ;
    -- --------------------------------
	drop trigger if exists borrar_tarjeta;
	delimiter //
	CREATE TRIGGER borrar_tarjeta AFTER DELETE ON usuario
		FOR EACH ROW 
		BEGIN
			DELETE FROM tarjetas WHERE usuario_dni = OLD.dni;
	end // 

	delimiter ;
    
	-- Comprobación
    
    Delete from cuenta where usuario_dni = '26543194K';
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	drop procedure if exists pide_usuario;
	delimiter $$
	create procedure pide_usuario(in llamada_dni char(9), out llamada_usuario char(9))
	begin
        set llamada_usuario = (select dni from usuario where dni = llamada_dni);
	end $$

	delimiter ;
    -- -------------------
	drop procedure if exists pide_bicicleta;
	delimiter $$
	create procedure pide_bicicleta(in id_bici_h int, out llamada_bici int)
	begin
        set llamada_bici = (select Id_bici from bicicleta where id_bici = id_bici_h);
	end $$

	delimiter ;
    -- --------------------
    drop procedure if exists alquilar_bici;
	delimiter $$
	create procedure alquilar_bici(in u char(9), in b int)
	begin
    
		call pide_usuario(u,@llamada_usuario);
		call pide_bicicleta(b, @llamada_bici);
		set @estado = (select estado from bicicleta where id_bici = @llamada_bici);
        
        if @estado = 0 then
        update bicicleta set estado = 1 where id_bici = @llamada_bici;
        else 
        update bicicleta set estado = 0 where id_bici = @llamada_bici;
        end if;
        
	end $$

	delimiter ;
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	drop trigger if exists crear_alquiler;
	delimiter //
	create trigger crear_alquiler after update on bicicleta
	for each row
	begin
    
		if new.estado != old.estado then
            if new.estado = 1 then
				insert into facturacion values (default, current_timestamp(), 0);
				insert into alquiler values (default, @llamada_usuario, @llamada_bici, current_timestamp(), null, null, last_insert_id());
            else
				update alquiler
                set fecha_devolucion = current_timestamp()
                where usuario_dni = @llamada_usuario and bicicleta_id_bici = @llamada_bici and fecha_devolucion is null;
			end if;
            
            call actualiza_total_viaje();
		end if;

	end //

	delimiter ;
    
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	drop procedure if exists actualiza_total_viaje;
	delimiter //
	create procedure actualiza_total_viaje ()
	begin
        
		update alquiler
		set total_viaje = timediff(fecha_devolucion,fecha_recogida)
		where usuario_dni = @llamada_usuario and bicicleta_id_bici = @llamada_bici and total_viaje is null;
		
	end //

	delimiter ;
    
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 call alquilar_bici ('22222222T',1);
 
 -- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 -- Recalcula los espacios vacíos y disponibles en las estaciones al alquilarse una bicileta 
   -- (funciona al ejeccutarse el trigger anterior)
   
    drop trigger if exists actualizar_estacion;
    delimiter //
    create trigger actualizar_estacion after update on bicicleta
    for each row 
    begin

        update estacion set espacios_vacios = espacios_vacios + 1 where id_estacion = (select estacion_id_estacion from bicicleta where id_bici = @llamada_bici);
        update estacion set disponibles = disponibles - 1 where id_estacion = (select estacion_id_estacion from bicicleta where id_bici = @llamada_bici);
        
    end //

    delimiter ;
    
    -- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    /*drop trigger if exists calcular_factura;
	delimiter //
	create trigger calcular_factura after update on bicicleta
	for each row
	begin
    
		
        
	end //

	delimiter ;*/
    
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* drop procedure if exists guarda_tarifa;
delimiter //
create procedure proc_mejor_nota()
begin
	
    declare guarda_total_viaje time;
    
end //

delimiter ; */

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- EVENTO 
 -- Se ejecuta cada día y elimina una autorizacion cuando un usuario cumple la mayoría de edad:
 
set global event_scheduler = ON;

drop event if exists EliminaAutorizacion;
create event EliminaAutorizacion
on schedule every 1 day starts now()
do
	call RevisaEdad();

-- CURSOR:
-- Para realizar el evento anterior se ha creado un cursor, este revisa cada usuario que tiene una 
-- autorización para verificar si es mayor de edad, si la condición se cumple entonces elimina la 
-- autorización de la base de datos.

drop procedure if exists RevisaEdad;
delimiter //
create procedure RevisaEdad()
begin
	-- declaracion de variables
    declare done boolean default false;
    declare fecha_naci date;
    declare dni_user char(9);
    
    -- declarar cursor para la consulta
    declare cursor_verificacion cursor for
    select dni, fecha_nacimiento from usuario u join autorizaciones a on u.dni = a.usuario_dni;
    
    -- declarar el manejador de error tipo "NOT FOUND"
    declare continue handler for not found set done = true;
    
    -- Abrir el cursor
    open cursor_verificacion;
    
    -- lectura de filas mediante bucle
    loop_lectura: loop
    
		-- lectura de la primera fila
        fetch cursor_verificacion into dni_user, fecha_naci;

        -- Si el cursor detecta que no hay fila para leer, salimos
        -- del loop
        if done then
			leave loop_lectura;
		end if;
        
		-- gestion de la verificacion de las fechas
        if timestampdiff(year,fecha_naci,curdate()) >= 18 then 
            delete from autorizaciones where usuario_dni = dni_user;
		end if;
    end loop;
    
    -- cerrar el cursor
    close cursor_verificacion;

end //

delimiter ;


-- COMPROBACIÓN:
-- Ejecutar para realizar la comprobación con uno de los usuarios de la base de datos.

update usuario
set fecha_nacimiento = "2004-09-16"
where dni = "81928337T";

select * from usuario;
select * from autorizaciones;
