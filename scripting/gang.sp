#pragma semicolon 1

#include <sourcemod>
#include <gang>
#include <regex>

#define PLUGIN_AUTHOR "Bara"
#define PLUGIN_VERSION "1.0.0-dev"

#include "gang/global.sp"
#include "gang/cache.sp"
#include "gang/sql.sp"
#include "gang/native.sp"
#include "gang/cmd.sp"
#include "gang/stock.sp"
#include "gang/menu.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_hSQLConnected = CreateGlobalForward("Gang_OnSQLConnected", ET_Ignore, Param_Cell);
	g_hGangCreated = CreateGlobalForward("Gang_OnGangCreated", ET_Ignore, Param_Cell, Param_Cell);
	g_hGangLeft = CreateGlobalForward("Gang_OnGangLeft", ET_Ignore, Param_Cell, Param_Cell);
	g_hGangDelete = CreateGlobalForward("Gang_OnGangDelete", ET_Ignore, Param_Cell, Param_Cell, Param_String);
	
	CreateNative("Gang_IsClientInGang", Native_IsClientInGang);
	CreateNative("Gang_GetClientAccessLevel", Native_GetClientAccessLevel);
	CreateNative("Gang_GetClientGang", Native_GetClientGang);
	CreateNative("Gang_ClientLeftGang", Native_LeftClientGang); // ToDo Gang Cache[iMembers]--;
	CreateNative("Gang_CreateClientGang", Native_CreateClientGang);
	CreateNative("Gang_DeleteClientGang", Native_DeleteClientGang);
	CreateNative("Gang_OpenClientGang", Native_OpenClientGang);
	
	CreateNative("Gang_GetGangName", Native_GetGangName);
	CreateNative("Gang_GetGangPoints", Native_GetGangPoints);
	CreateNative("Gang_GetGangMaxMembers", Native_GetGangMaxMembers);
	CreateNative("Gang_GetGangMembersCount", Native_GetGangMembersCount);
	CreateNative("Gang_GetOnlinePlayerCount", Native_GetOnlinePlayerCount);
	
	RegPluginLibrary("gang");
	
	return APLRes_Success;
}

public Plugin myinfo = 
{
	name = "Gang - Core",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "gang.ovh"
};

public void OnPluginStart()
{
	Gang_CheckGame();
	Gang_CreateCache();
	Gang_SQLConnect();
	
	g_cGangCreate = CreateConVar("gang_create_enable", "1", "Enable \"Create Gang\"?", _, true, 0.0, true, 1.0);
	g_cGangMinLen = CreateConVar("gang_create_min_length", "3", "Minimum length of gang name", _, true, 3.0, true, 8.0);
	g_cGangMaxLen = CreateConVar("gang_create_max_length", "8", "Maximum length of gang name", _, true, 3.0, true, 8.0);
	g_cGangRegex =  CreateConVar("gang_create_regex", "^[a-zA-Z0-9]+$", "Allowed characters in gang name");
	
	AutoExecConfig();
	
	RegConsoleCmd("sm_gang", Command_Gang);
	RegConsoleCmd("sm_creategang", Command_CreateGang);
	RegConsoleCmd("sm_listgang", Command_ListGang);
	RegConsoleCmd("sm_leftgang", Command_LeftGang);
	RegConsoleCmd("sm_deletegang", Command_DeleteGang);
}

public void OnClientPutInServer(int client)
{
	Gang_PushClientArray(client);
}

public void OnClientDisconnect(int client)
{
	Gang_EraseClientArray(client);
}
