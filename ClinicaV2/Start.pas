Program Pzim ;


type
	type_medico = record
	nome:string;
	cpf:string;
	crm:string;
	telefone:string;
	endereco:string
end;

	type_paciente = record
	nome:string;
	cpf:string;
	observacoes:string;
	telefone:string;
	endereco:string
end;

	type_consulta = record
	data:string;
	valor:real;
	medico:type_medico;
	paciente:type_paciente;
end;

db_medicos = file of type_medico;
db_pacientes = file of type_paciente;
db_consultas = file of type_consulta;


var
	medicos:db_medicos;
	pacientes:db_pacientes;
	consultas:db_consultas;


{
 	Criar Arquivos de Database caso não existam
}

procedure createDatabases(var m:db_medicos; var p:db_pacientes; var c:db_consultas);
begin
//Criar DB Medicos
		reset(m);
		if ioresult <> 0 then
		rewrite(m);
		close(m);		
//Criar DB Pacientes		
		reset(p);
		if ioresult <> 0 then
		rewrite(p);
		close(p);		
//Criar DB Consultas		
		reset(c);
		if ioresult <> 0 then
		rewrite(c);
		close(c);
end;

Begin	
	createDatabases(medicos,pacientes,consultas);	
End.