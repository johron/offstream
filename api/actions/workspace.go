package actions

import "api/util"

func GetWorkspace() util.ActionResponse {
	err, workspace := util.ReadWorkspaceFile()
	if err == nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to read workspace",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "workspace retrieved successfully",
		Return:  workspace,
	}
}

func InitWorkspace(version string, token string) util.ActionResponse {
	workspace := &util.Workspace{
		Version: version,
		Token:   token,
	}

	workspaceErr := util.WriteWorkspaceFile(workspace)
	if workspaceErr != nil {
		return util.ActionResponse{
			Success: false,
			Message: "failed to initialize workspace",
		}
	}

	return util.ActionResponse{
		Success: true,
		Message: "workspace initialized successfully",
	}
}
