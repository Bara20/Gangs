public Action Command_CreateGang(int client, int args)
{
	if(!g_cGangCreate.BoolValue)
	{
		PrintToChat(client, "Es können derzeit keine Gangs erstellt werden!");
		return Plugin_Handled;
	}
	
	if(args < 1)
	{
		PrintToChat(client, "Syntax: sm_creategang <Name>");
		return Plugin_Handled;
	}
	
	char sArg[64];
	GetCmdArgString(sArg, sizeof(sArg));
	
	Gang_CreateClientGang(client, sArg);
	return Plugin_Handled;
}

public Action Command_ListGang(int client, int args)
{
	if (client < 1 )
		return Plugin_Handled;
	
	Menu mMenu = new Menu(Menu_GangList);
	mMenu.SetTitle("Gang list");
	
	for (int i = 0; i < g_aCacheGang.Length; i++)
	{
		int iGang[Cache_Gang];
		g_aCacheGang.GetArray(i, iGang[0]);

		mMenu.AddItem("", iGang[sGangName], ITEMDRAW_DISABLED);
	}
	
	mMenu.ExitButton = true;
	mMenu.Display(client, 0);
	
	return Plugin_Handled;
}

public Action Command_LeftGang(int client, int args)
{
	Gang_ClientLeftGang(client);
	
	return Plugin_Handled;
}

public Action Command_DeleteGang(int client, int args)
{
	Gang_DeleteClientGang(client, Gang_GetClientGang(client));
	
	return Plugin_Handled;
}
