// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Administrators can use this page to synchronize information about users from Office 365 to Business Central.
/// </summary>
page 9515 "Azure AD User Update Wizard"
{
    Caption = 'Update users from Office 365';
    PageType = NavigatePage;
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;
    SourceTable = "Azure AD User Update Buffer";
    SourceTableTemporary = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(Welcome)
            {
                Visible = WelcomeVisible;
                Caption = 'Welcome to user updates';
                group(HeaderText)
                {
                    ShowCaption = false;
                    Caption = 'Description';
                    InstructionalText = 'Bring changes to user information from your Office 365 organization to Business Central. Update license assignments, name changes, email addresses, preferred languages, and user access.';
                }
                group(NoteGroup)
                {
                    Caption = 'Note:';
                    InstructionalText = 'It can take up to 72 hours for a change in Office 365 to become available to Business Central. If a change within that period does not appear in Business Central after you update users, try again later.';
                }
            }
            group(AvailableUpdates)
            {
                Visible = AvailableUpdatesVisible;
                Caption = 'Available Updates';
                group(TotalUpdatesGroup)
                {
                    ShowCaption = false;
                    label(TotalUpdatesAvailableLbl)
                    {
                        ApplicationArea = All;
                        CaptionClass = TotalUpdatesAvailable;
                        ShowCaption = false;
                    }
                    label(TotalUpdatesToConfirmLbl)
                    {
                        ApplicationArea = All;
                        CaptionClass = TotalUpdatesToConfirm;
                        ShowCaption = false;
                        Visible = TotalUpdatesToConfirmVisible;
                    }
                    label(TotalUpdatesReadyToApplyLbl)
                    {
                        ApplicationArea = All;
                        CaptionClass = TotalUpdatesReadyToApply;
                        ShowCaption = false;
                        Visible = TotalUpdatesReadyToApplyVisible;
                    }
                }
            }
            group(ConfirmPermissionChanges)
            {
                Visible = ConfirmPermissionChangesVisible;
                Caption = 'Confirm permission changes';
                InstructionalText = 'Apply the permissions from the new license or keep the current permissions.';
                group(PermissionsGroup)
                {
                    ShowCaption = false;
                    repeater(Permissions)
                    {
                        field(DisplayName; "Display Name")
                        {
                            ToolTip = 'The display name';
                            ApplicationArea = All;
                        }
                        field(CurrentLicense; "Current Value")
                        {
                            Caption = 'Current plan';
                            ToolTip = 'The current of user entity';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field(NewLicense; "New Value")
                        {
                            Caption = 'New plan';
                            ToolTip = 'The new value of user entity';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field(PermissionAction; "Permission Change Action")
                        {
                            Caption = 'Action';
                            ToolTip = 'Choose how this license change should be handled';
                            ApplicationArea = All;
                            Enabled = "Update Type" = "Update Type"::Change;
                        }
                    }
                }
            }
            group(ListOfChanges)
            {
                Visible = ListOfChangesVisible;
                Caption = 'List of changes';
                InstructionalText = 'These changes will be applied when you choose Finish.';
                group(ChangesGroup)
                {
                    ShowCaption = false;
                    repeater(Changes)
                    {
                        field("Display Name"; "Display Name")
                        {
                            ToolTip = 'The display name';
                            ApplicationArea = All;
                        }
                        field("Authentication Object ID"; "Authentication Object ID")
                        {
                            ToolTip = 'The AAD user ID';
                            ApplicationArea = All;
                            Visible = false;
                        }
                        field("Update Type"; "Update Type")
                        {
                            ToolTip = 'The type of update';
                            ApplicationArea = All;
                        }
                        field("Information"; "Update Entity")
                        {
                            ToolTip = 'The user information that will be updated';
                            ApplicationArea = All;
                        }
                        field("Current Value"; "Current Value")
                        {
                            ToolTip = 'The current value';
                            ApplicationArea = All;
                        }
                        field("New Value"; "New Value")
                        {
                            ToolTip = 'The value to replace the user information';
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(Finished)
            {
                Visible = FinishedVisible;
                Caption = 'Good work!';
                group(NumberOfUpdatesAppliedGroup)
                {
                    Caption = 'Summary';
                    label(NumberOfUpdatesApplied)
                    {
                        ApplicationArea = All;
                        CaptionClass = NumberOfUpdatesApplied;
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                ToolTip = 'Cancel the user updates';
                Image = Cancel;
                Visible = CancelButtonVisible;
                InFooterBar = true;

                trigger OnAction()
                var
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if ConfirmManagement.GetResponse(ConfirmCancelQst, false) then
                        CurrPage.Close();
                end;
            }
            action(Back)
            {
                ApplicationArea = All;
                Caption = 'Back';
                ToolTip = 'See overview of all the changes';
                Image = PreviousRecord;
                Visible = BackButtonVisible;
                InFooterBar = true;

                trigger OnAction()
                begin
                    MakeAllGroupsInvisible();
                    AvailableUpdatesVisible := true;
                    SetVisiblityOnActions();
                    TotalUpdatesAvailable := StrSubstNo(TotalUpdatesAvailableTxt, CountOfApplicableUpdates + CountOfManagedPermissionUpdates);
                    TotalUpdatesReadyToApply := StrSubstNo(TotalUpdatesReadyToApplyTxt, CountOfApplicableUpdates);
                    TotalUpdatesReadyToApplyVisible := CountOfApplicableUpdates > 0;
                    TotalUpdatesToConfirm := StrSubstNo(TotalUpdatesToConfirmTxt, CountOfManagedPermissionUpdates);
                    TotalUpdatesToConfirmVisible := CountOfManagedPermissionUpdates > 0;
                end;
            }
            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                ToolTip = 'See the available updates';
                Image = NextRecord;
                Visible = NextButtonVisible;
                InFooterBar = true;

                trigger OnAction()
                var
                    AzureADUserMgtImpl: Codeunit "Azure AD User Mgmt. Impl.";
                begin
                    AzureADUserMgtImpl.FetchUpdatesFromAzureGraph(Rec);

                    MakeAllGroupsInvisible();
                    AvailableUpdatesVisible := true;
                    SetVisiblityOnActions();
                    TotalUpdatesAvailable := StrSubstNo(TotalUpdatesAvailableTxt, CountOfApplicableUpdates + CountOfManagedPermissionUpdates);
                    TotalUpdatesReadyToApply := StrSubstNo(TotalUpdatesReadyToApplyTxt, CountOfApplicableUpdates);
                    TotalUpdatesReadyToApplyVisible := CountOfApplicableUpdates > 0;
                    TotalUpdatesToConfirm := StrSubstNo(TotalUpdatesToConfirmTxt, CountOfManagedPermissionUpdates);
                    TotalUpdatesToConfirmVisible := CountOfManagedPermissionUpdates > 0;
                end;
            }
            action(ManagePermissionUpdates)
            {
                ApplicationArea = All;
                Caption = 'Manage permission updates';
                ToolTip = 'Confirm the permission updates to be applied';
                Visible = ManagePermissionUpdatesButtonVisible;
                Image = Questionaire;
                InFooterBar = true;

                trigger OnAction()
                begin
                    MakeAllGroupsInvisible();
                    SetVisiblityOnActions();
                    BackButtonVisible := true;
                    ManagePermissionUpdatesButtonVisible := false;
                    ConfirmPermissionChangesVisible := true;
                    SetRange("Update Entity", "Update Entity"::Plan);
                end;
            }
            action(ViewChanges)
            {
                ApplicationArea = All;
                Caption = 'View changes';
                ToolTip = 'View a list of changes that will be applied';
                Visible = ViewChangesButtonVisible;
                Image = Change;
                InFooterBar = true;

                trigger OnAction()
                begin
                    MakeAllGroupsInvisible();
                    ListOfChangesVisible := true;
                    SetVisiblityOnActions();
                    BackButtonVisible := true;
                    ViewChangesButtonVisible := false;
                    SetRange("Needs User Review", false);
                end;
            }
            action(ApplyUpdates)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                ToolTip = 'Apply the user updates';
                Visible = ApplyUpdatesButtonVisible;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                var
                    AzureADUserMgtImpl: Codeunit "Azure AD User Mgmt. Impl.";
                    SuccessCount: Integer;
                begin
                    Reset();
                    SuccessCount := AzureADUserMgtImpl.ApplyUpdatesFromAzureGraph(Rec);
                    NumberOfUpdatesApplied := StrSubstNo(NumberOfUpdatesAppliedTxt, SuccessCount, Count());
                    DeleteAll();

                    MakeAllGroupsInvisible();
                    FinishedVisible := true;
                    SetVisiblityOnActions();
                    ApplyUpdatesButtonVisible := false;
                    CancelButtonVisible := false;
                    CloseButtonVisible := true;
                end;
            }
            action(Close)
            {
                ApplicationArea = All;
                Caption = 'Close';
                ToolTip = 'Closes this window';
                Image = Close;
                Visible = CloseButtonVisible;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        [InDataSet]
        WelcomeVisible: Boolean;
        [InDataSet]
        AvailableUpdatesVisible: Boolean;
        [InDataSet]
        ConfirmPermissionChangesVisible: Boolean;
        [InDataSet]
        ListOfChangesVisible: Boolean;
        [InDataSet]
        FinishedVisible: Boolean;

        [InDataSet]
        CancelButtonVisible: Boolean;
        [InDataSet]
        BackButtonVisible: Boolean;
        [InDataSet]
        NextButtonVisible: Boolean;
        [InDataSet]
        ManagePermissionUpdatesButtonVisible: Boolean;
        [InDataSet]
        ViewChangesButtonVisible: Boolean;
        [InDataSet]
        ApplyUpdatesButtonVisible: Boolean;
        [InDataSet]
        CloseButtonVisible: Boolean;

        CountOfManagedPermissionUpdates: Integer;
        CountOfApplicableUpdates: Integer;

        ConfirmCancelQst: Label 'Are you sure you wish to cancel the updates?';
        NumberOfUpdatesApplied: Text;
        NumberOfUpdatesAppliedTxt: Label '%1 out of %2 updates have been applied in Business Central. You can close this guide.', Comment = '%1 = An integer count of total updates applied; %2 = total count of updates';

        TotalUpdatesAvailable: Text;
        TotalUpdatesAvailableTxt: Label 'Number of available updates: %1.', Comment = '%1 = An integer count of total updates to apply';

        TotalUpdatesToConfirm: Text;
        TotalUpdatesToConfirmVisible: Boolean;
        TotalUpdatesToConfirmTxt: Label 'Number of license updates for users who have customized permissions: %1. The default permissions from the new license will replace the custom permissions. You must either apply the new permissions now or keep the current permissions. To do that, choose Manage permission updates.', Comment = '%1 = An integer count of total updates to get confirmation on';

        TotalUpdatesReadyToApply: Text;
        TotalUpdatesReadyToApplyVisible: Boolean;
        TotalUpdatesReadyToApplyTxt: Label 'Number of available changes: %1. These can be name, email address, preferred language, and user access changes. Choose View changes to see the list.', Comment = '%1 = An integer count of total updates ready to apply';

        CannotUpdateUsersFromOfficeErr: Label 'You do not have sufficient previleges to update users from Office 365';

    trigger OnOpenPage()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        if not UserPermissions.CanManageUsersOnTenant(UserSecurityId()) then
            error(CannotUpdateUsersFromOfficeErr);

        MakeAllGroupsInvisible();
        WelcomeVisible := true;

        SetVisiblityOnActions();
        NextButtonVisible := true;
    end;

    local procedure MakeAllGroupsInvisible()
    begin
        WelcomeVisible := false;
        AvailableUpdatesVisible := false;
        ConfirmPermissionChangesVisible := false;
        ListOfChangesVisible := false;
        FinishedVisible := false;
    end;

    local procedure SetVisiblityOnActions()
    var
        TotalNumberOfUpdates: Integer;
    begin
        Reset();
        CancelButtonVisible := true;
        BackButtonVisible := false;
        NextButtonVisible := false;
        CloseButtonVisible := false;
        TotalNumberOfUpdates := Count();

        SetRange("Needs User Review", true);
        CountOfManagedPermissionUpdates := Count();
        CountOfApplicableUpdates := TotalNumberOfUpdates - CountOfManagedPermissionUpdates;

        ApplyUpdatesButtonVisible := (CountOfManagedPermissionUpdates = 0) and (CountOfApplicableUpdates > 0);
        ManagePermissionUpdatesButtonVisible := CountOfManagedPermissionUpdates > 0;
        ViewChangesButtonVisible := CountOfApplicableUpdates > 0;
        SetRange("Needs User Review");
        if CountOfApplicableUpdates + CountOfManagedPermissionUpdates = 0 then begin
            CloseButtonVisible := true;
            CancelButtonVisible := false;
        end;
    end;
}