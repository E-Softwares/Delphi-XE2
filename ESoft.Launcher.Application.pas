Unit ESoft.Launcher.Application;

{ ---------------------------------------------------------- }
{ Developed by Muhammad Ajmal p }
{ ajumalp@gmail.com }
{ ---------------------------------------------------------- }

Interface

Uses
   Winapi.Windows,
   System.Classes,
   System.StrUtils,
   System.Types,
   Vcl.Forms,
   IniFiles,
   Vcl.Dialogs,
   Vcl.Controls,
   System.SysUtils,
   ShellApi,
   Vcl.Graphics,
{$IFDEF AbbreviaZipper}
   AbBase,
   AbBrowse,
   AbZBrows,
   AbUnzper,
   AbComCtrls,
   AbArcTyp,
{$ELSE}
   System.Zip,
{$ENDIF}
   Generics.Collections,
   ESoft.Launcher.RecentItems,
   ESoft.Utils;

Const
   cParameterPick = '<ePick>';
   cParameterAll = '<eAll>';
   cInvalidBuildNumber = -1;
   cInvalidBuildCaption = 'Invalid Builds';

   cGroupType_Application = 0;
   cGroupType_Folder = 1;
   cGroupType_ZipFiles = 2;

Type
   eTAppFile = (eafName, eafFileName, eafExtension);

Type
   TEApplicationGroup = Class;

   TEApplication = Class(TPersistent, IEApplication)
   Private
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FOwner: TEApplicationGroup;
      FFileName: String;
      FVersionName: TStringDynArray;
      FLastUsedParamName: String; // This we reset with application restart { Ajmal }

      Function GetActualName: String;
      Function GetISFixedParameter: Boolean;
      Function GetFixedParameter: String;
      Function GetLastUsedParamName: String;
      procedure SetLastUsedParamName(const aValue: String);
      Function GetFileName(aType: eTAppFile): String;
      Procedure SetOwner(Const Value: TEApplicationGroup);

   Public
      Constructor Create(Const aOwner: TEApplicationGroup);

      Function QueryInterface(Const IID: TGUID; Out Obj): HRESULT; Stdcall;
      Function _AddRef: Integer; Stdcall;
      Function _Release: Integer; Stdcall;

      Function TargetBranchPath: String;
      Function TargetFolder: String;
      Function RunExecutable(aParameter: String = ''): Boolean;
      Function UnZip: Boolean;
      Function CopyFromSourceFolder: Boolean;

      Function VersionName: TStringDynArray;
      Function MajorVersionName: String;
      Function MinorVersionName: String;
      Function ReleaseVersionName: String;
      Function BuildNumber: Integer;
   Published
      Property Owner: TEApplicationGroup Read FOwner Write SetOwner;
      Property Name: String Index eafName Read GetFileName;
      Property Extension: String Index eafExtension Read GetFileName;
      Property FileName: String Index eafFileName Read GetFileName Write FFileName;
      Property IsFixedParameter: Boolean Read GetISFixedParameter;
   End;

   TEApplications = Class(TObjectList<TEApplication>);

   TEApplicationGroup = Class(TEApplications, IEApplication)
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FGroupType: Integer;
      FFixedParameter, FExecutableName, FName: String;
      FLastUsedParamName: String;
      FISFixedParameter: Boolean;
      FSourceFolder, FSourceFolderPrefix: String;
      FSourceFolderCopyTo: String;
      FDestFolder: String;
      FFileMask: String;
      FDisplayLabel: String;
      FCreateFolder, FCreateBranchFolder, FSkipFromRecent: Boolean;
      FIcon: TIcon;
      FIsMajorBranching, FIsMinorBranching, FIsReleaseBranching: Boolean;
      FBranchingPrefix, FBranchingSufix: String;
      FMainBranch, FCurrentBranch, FNoOfBuilds: Integer;

      Function GetIsApplication: Boolean;
      Function GetActualName: String;
      Function GetISFixedParameter: Boolean;
      Function GetFixedParameter: String;
      Function GetLastUsedParamName: String;
      procedure SetLastUsedParamName(const aValue: String);
      Procedure SetSourceFolder(Const Value: String);
      Procedure SetSourceFolderCopyTo(Const aValue: String);
      Procedure SetDestFolder(Const Value: String);
      Procedure SetFileMask(Const Value: String);
      Function AddItem: TEApplication;
      Function InsertItem(Const aIndex: Integer): TEApplication;
      Function GetIcon: TIcon;
      Function GetFinalSourceFolder: String;  
      procedure SetSourceFolderPrefix(const Value: String);
   Public
      Constructor Create;
      Destructor Destroy; Override;

      Function QueryInterface(Const IID: TGUID; Out Obj): HRESULT; Stdcall;
      Function _AddRef: Integer; Stdcall;
      Function _Release: Integer; Stdcall;

      Function TargetFolder: String;
      Function RunExecutable(aParameter: String = ''): Boolean;
      Function UnZip: Boolean;
      Function CopyFromSourceFolder: Boolean;
      Function NeedToCopy: Boolean;
      Procedure LoadApplications;
      Procedure LoadData(Const aFileName: String);
      Procedure SaveData(Const aFileName: String);

      Function IsBranchingEnabled: Boolean;
      Property FinalSourceFolder: String Read GetFinalSourceFolder;
   Published
      Property Name: String Read FName Write FName;
      Property ExecutableName: String Read FExecutableName Write FExecutableName;
      Property FileMask: String Read FFileMask Write SetFileMask;
      Property DestFolder: String Read FDestFolder Write SetDestFolder;
      Property SourceFolder: String Read FSourceFolder Write SetSourceFolder;
      Property SourceFolderPrefix: String Read FSourceFolderPrefix Write FSourceFolderPrefix;
      Property SourceFolderCopyTo: String Read FSourceFolderCopyTo Write SetSourceFolderCopyTo;
      Property CreateFolder: Boolean Read FCreateFolder Write FCreateFolder;
      Property SkipFromRecent: Boolean Read FSkipFromRecent Write FSkipFromRecent;
      Property FixedParameter: String Read GetFixedParameter Write FFixedParameter;
      Property ISFixedParameter: Boolean Read GetISFixedParameter Write FISFixedParameter;
      Property LastUsedParamName: String Read GetLastUsedParamName Write SetLastUsedParamName;
      Property IsApplication: Boolean Read GetIsApplication;
      Property DisplayLabel: String Read FDisplayLabel Write FDisplayLabel;
      Property Icon: TIcon Read GetIcon;
      Property IsMajorBranching: Boolean Read FIsMajorBranching Write FIsMajorBranching;
      Property IsMinorBranching: Boolean Read FIsMinorBranching Write FIsMinorBranching;
      Property IsReleaseBranching: Boolean Read FIsReleaseBranching Write FIsReleaseBranching;
      Property BranchingPrefix: String Read fBranchingPrefix Write FBranchingPrefix;
      Property BranchingSufix: String Read FBranchingSufix Write FBranchingSufix;
      Property NoOfBuilds: Integer Read FNoOfBuilds Write FNoOfBuilds;
      Property MainBranch: Integer Read FMainBranch Write FMainBranch;
      Property CurrentBranch: Integer Read FCurrentBranch Write FCurrentBranch;
      Property CreateBranchFolder: Boolean Read FCreateBranchFolder Write FCreateBranchFolder;
      Property GroupType: Integer Read FGroupType Write FGroupType;
   End;

Type
   TEApplicationGroups = Class(TObjectDictionary<String, TEApplicationGroup>)
   Private
      // Private declarations. Variables/Methods can be access inside this class and other class in the same unit. { Ajmal }
   Strict Private
      // Strict Private declarations. Variables/Methods can be access inside this class only. { Ajmal }
      FIsLoaded: Boolean;

   Public
      Constructor Create;

      Procedure LoadData(Const aFileName: String);
      Procedure SaveData(Const aFileName: String);
      Function DeleteGroup(Const aFileName, aGroupName: String): Boolean;
      Function AddItem(Const aName: String = ''): TEApplicationGroup;
   End;

Implementation

{ TEApplicationGroup }

Uses
   UnitMDIMain,
   ESoft.Launcher.UI.ParamBrowser,
   ESoft.UI.Downloader;

Const
   cBRANCH_MAJOR_VERSION = 0;
   cBRANCH_MINOR_VERSION = 1;
   cBRANCH_RELEASE_VERSION = 2;
   cBRANCH_BUILD_VERSION = 3;
   cBRANCH_VERSION_SEPERATOR = '.';

   cGroupLastUsedParam = 'Last_Used_Param';
   cGroupFixedParam = 'Fixed_Param';
   cGroupIsFixedParam = 'Is_Fixed_Param';
   cGroupExeName = 'Executable_Name';
   cGroupFileMask = 'File_Mask';
   cGroupSourceFolder = 'Source_Folder';
   cGroupSourceFolderPrefix = 'Source_Folder_Prefix';
   cGroupSourceFolderCopyTo = 'Source_Folder_CopyTo';
   cGroupDestFolder = 'Target_Folder';
   cGroupCreateFolder = 'Create_Folder';
   cGroupSkipFromRecent = 'Skip_From_Recent';
   cGroupType = 'Group_Type';
   cGroupLabel = 'Display_Label';
   cGroupIsMajorBranching = 'Is_MajorBranching';
   cGroupIsMinorBranching = 'Is_MinorBranching';
   cGroupIsReleaseBranching = 'Is_ReleaseBranching';
   cGroupBranchingPrefix = 'BranchingPrefix';
   cGroupBranchingSufix = 'BranchingSufix';
   cGroupBranchingMainBranch = 'BranchingMainBranch';
   cGroupBranchingNoOfBuilds = 'BranchingNoOfBuilds';
   cGroupBranchingCurrentBranch = 'BranchingCurrentBranch';
   cGroupBranchingCreateFolder = 'BranchingCreateFolder';

Function TEApplicationGroup.AddItem: TEApplication;
Begin
   Result := TEApplication.Create(Self);
   Add(Result);
End;

Function TEApplicationGroup.CopyFromSourceFolder: Boolean;
Begin
   Result := True;
End;

Constructor TEApplicationGroup.Create;
Begin
   Inherited Create(True);

   FCreateFolder := True;
   FSkipFromRecent := False;
   FSourceFolder := '';
   FDestFolder := '';
End;

Destructor TEApplicationGroup.Destroy;
Begin
   EFreeAndNil(FIcon);

   Inherited;
End;

Function TEApplicationGroup.InsertItem(Const aIndex: Integer): TEApplication;
Begin
   Result := TEApplication.Create(Self);
   Insert(aIndex, Result);
End;

Function TEApplicationGroup.IsBranchingEnabled: Boolean;
Begin
   Result := IsMajorBranching Or IsMinorBranching Or IsReleaseBranching Or (NoOfBuilds > 0);
End;

Function TEApplicationGroup.GetActualName: String;
Begin
   Result := Name;
End;

Function TEApplicationGroup.GetFinalSourceFolder: String;
Begin
   If NeedToCopy Then
      Result := SourceFolderCopyTo
   Else
      Result := SourceFolder;
End;

function TEApplicationGroup.GetFixedParameter: String;
begin
   Result := FFixedParameter;
end;

Function TEApplicationGroup.GetIcon: TIcon;
Var
   sFileName: String;
Begin
   Result := Nil;

   If IsApplication Then
      sFileName := FinalSourceFolder + ExecutableName
   Else
      sFileName := DestFolder + ExecutableName;

   EFreeAndNil(FIcon);
   If ExtractFileExt(sFileName) = '' Then
      Exit;

   If not FileExists(sFileName) Then
    Exit;

   FIcon := TIcon.Create;
   Try
      FetchIcon(sFileName, FIcon);
      Result := FIcon;
   Except
      // Do nothing, it's not mandatory to have icon { Ajmal }
   End;
End;

Function TEApplicationGroup.GetIsApplication: Boolean;
Begin
   Result := GroupType = cGroupType_Application;
End;

function TEApplicationGroup.GetISFixedParameter: Boolean;
begin
   Result := FISFixedParameter;
end;

Function TEApplicationGroup.GetLastUsedParamName: String;
Begin
   Result := FLastUsedParamName;
End;

Procedure TEApplicationGroup.LoadApplications;
Var
   varSearch: TSearchRec;
Begin
   Clear;
   If SourceFolder <> '' Then
   Begin
      If FindFirst(SourceFolder + FileMask, faArchive, varSearch) = 0 Then
      Begin
         Repeat
            InsertItem(0).FileName := varSearch.Name;
         Until FindNext(varSearch) <> 0;
         FindClose(varSearch);
      End;
   End;
End;

Procedure TEApplicationGroup.LoadData(Const aFileName: String);
Var
   varIniFile: TIniFile;
Begin
   varIniFile := TIniFile.Create(aFileName);
   Try
      FixedParameter := varIniFile.ReadString(Name, cGroupFixedParam, '');
      ISFixedParameter := varIniFile.ReadBool(Name, cGroupIsFixedParam, (FixedParameter <> cParameterPick));
      ExecutableName := varIniFile.ReadString(Name, cGroupExeName, '');
      FileMask := varIniFile.ReadString(Name, cGroupFileMask, '');
      SourceFolder := varIniFile.ReadString(Name, cGroupSourceFolder, '');
      SourceFolderPrefix := varIniFile.ReadString(Name, cGroupSourceFolderPrefix, '');
      SourceFolderCopyTo := varIniFile.ReadString(Name, cGroupSourceFolderCopyTo, '');
      DestFolder := varIniFile.ReadString(Name, cGroupDestFolder, '');
      CreateFolder := varIniFile.ReadBool(Name, cGroupCreateFolder, True);
      SkipFromRecent := varIniFile.ReadBool(Name, cGroupSkipFromRecent, False);
      // Is_Application should be removed soon { Ajmal }
      GroupType := varIniFile.ReadInteger(Name, 'Is_Application', -1);
      If GroupType = -1 Then
         GroupType := varIniFile.ReadInteger(Name, cGroupType, 0)
      Else
      Begin
         GroupType := IfThen(GroupType = 0, 2, 0);
         varIniFile.DeleteKey(Name, 'Is_Application');
      End;

      DisplayLabel := varIniFile.ReadString(Name, cGroupLabel, '');
      IsMajorBranching := varIniFile.ReadBool(Name, cGroupIsMajorBranching, False);
      IsMinorBranching := varIniFile.ReadBool(Name, cGroupIsMinorBranching, False);
      IsReleaseBranching := varIniFile.ReadBool(Name, cGroupIsReleaseBranching, False);
      BranchingPrefix := varIniFile.ReadString(Name, cGroupBranchingPrefix, '');
      BranchingSufix := varIniFile.ReadString(Name, cGroupBranchingSufix, '');
      MainBranch := varIniFile.ReadInteger(Name, cGroupBranchingMainBranch, 0);
      NoOfBuilds := varIniFile.ReadInteger(Name, cGroupBranchingNoOfBuilds, 0);
      CurrentBranch := varIniFile.ReadInteger(Name, cGroupBranchingCurrentBranch, 0);
      CreateBranchFolder := varIniFile.ReadBool(Name, cGroupBranchingCreateFolder, False);
   Finally
      varIniFile.Free;
   End;
End;

Function TEApplicationGroup.NeedToCopy: Boolean;
Begin
  Result := (Trim(SourceFolderCopyTo) <> '') And DirectoryExists(SourceFolderCopyTo);
End;

Function TEApplicationGroup.QueryInterface(Const IID: TGUID; Out Obj): HRESULT;
Begin
   Inherited;
End;

Function TEApplicationGroup.RunExecutable(aParameter: String): Boolean;
Begin
   If Not IsApplication Then
      Raise Exception.Create('Execution failed. Group is not created as application.');

   If ISFixedParameter Then
      aParameter := aParameter + ' ' + FixedParameter;

   FormMDIMain.RunApplication(Name, ExecutableName, aParameter, FinalSourceFolder, SkipFromRecent);
End;

Procedure TEApplicationGroup.SaveData(Const aFileName: String);
Var
   varIniFile: TIniFile;
Begin
   varIniFile := TIniFile.Create(aFileName);
   Try
      varIniFile.WriteString(Name, cGroupFixedParam, FixedParameter);
      varIniFile.WriteBool(Name, cGroupIsFixedParam, ISFixedParameter);
      varIniFile.WriteString(Name, cGroupExeName, ExecutableName);
      varIniFile.WriteString(Name, cGroupFileMask, FileMask);
      varIniFile.WriteString(Name, cGroupSourceFolder, SourceFolder);
      varIniFile.WriteString(Name, cGroupSourceFolderPrefix, SourceFolderPrefix);
      varIniFile.WriteString(Name, cGroupSourceFolderCopyTo, SourceFolderCopyTo);
      varIniFile.WriteString(Name, cGroupDestFolder, DestFolder);
      varIniFile.WriteBool(Name, cGroupCreateFolder, CreateFolder);
      varIniFile.WriteBool(Name, cGroupSkipFromRecent, SkipFromRecent);
      varIniFile.WriteInteger(Name, cGroupType, GroupType);
      varIniFile.WriteString(Name, cGroupLabel, DisplayLabel);
      varIniFile.WriteBool(Name, cGroupIsMajorBranching, IsMajorBranching);
      varIniFile.WriteBool(Name, cGroupIsMinorBranching, IsMinorBranching);
      varIniFile.WriteBool(Name, cGroupIsReleaseBranching, IsReleaseBranching);
      varIniFile.WriteString(Name, cGroupBranchingPrefix, BranchingPrefix);
      varIniFile.WriteString(Name, cGroupBranchingSufix, BranchingSufix);
      varIniFile.WriteInteger(Name, cGroupBranchingMainBranch, MainBranch);
      varIniFile.WriteInteger(Name, cGroupBranchingNoOfBuilds, NoOfBuilds);
      varIniFile.WriteInteger(Name, cGroupBranchingCurrentBranch, CurrentBranch);
      varIniFile.WriteBool(Name, cGroupBranchingCreateFolder, CreateBranchFolder);
   Finally
      varIniFile.Free;
   End;
End;

Procedure TEApplicationGroup.SetDestFolder(Const Value: String);
Var
   iLen: Integer;
Begin
   iLen := Length(Value);
   If (iLen > 0) And (Value[iLen] <> '\') Then
      FDestFolder := Value + '\'
   Else
      FDestFolder := Value;
End;

Procedure TEApplicationGroup.SetFileMask(Const Value: String);
Begin
   FFileMask := Value;
End;

Procedure TEApplicationGroup.SetLastUsedParamName(const aValue: String);
Var
   varIniFile: TIniFile;
Begin
   FLastUsedParamName := aValue;

   // We need to write this param immediately { Ajmal }
   varIniFile := TIniFile.Create(FormMDIMain.ParentFolder + cGroup_INI);
   Try
      varIniFile.WriteString(Name, cGroupLastUsedParam, LastUsedParamName);
   Finally
      varIniFile.Free;
   End;
End;

Procedure TEApplicationGroup.SetSourceFolder(Const Value: String);
Var
   iLen: Integer;
Begin
   iLen := Length(Value);
   If (iLen > 0) And (Value[iLen] <> '\') Then
      FSourceFolder := Value + '\'
   Else
      FSourceFolder := Value;
End;

Procedure TEApplicationGroup.SetSourceFolderCopyTo(Const aValue: String);
Var
   iLen: Integer;
Begin
   iLen := Length(aValue);
   If (iLen > 0) And (aValue[iLen] <> '\') Then
      FSourceFolderCopyTo := aValue + '\'
   Else
      FSourceFolderCopyTo := aValue;
End;

procedure TEApplicationGroup.SetSourceFolderPrefix(const Value: String);
begin
  FSourceFolderPrefix := Value;
end;

Function TEApplicationGroup.TargetFolder: String;
Begin
   If CreateFolder Then
      Result := DestFolder // + Copy(ExecutableName, 1, Length(FFileName) - Length(ExtractFileExt(FFileName)))
   Else
      Result := DestFolder;
End;

Function TEApplicationGroup.UnZip: Boolean;
Begin
   Result := True;
End;

Function TEApplicationGroup._AddRef: Integer;
Begin
   Inherited;
End;

Function TEApplicationGroup._Release: Integer;
Begin
   Inherited;
End;

{ TEApplicationGroups }

Function TEApplicationGroups.AddItem(Const aName: String): TEApplicationGroup;
Begin
   If ContainsKey(aName) Then
      Raise Exception.Create('Group with same name already exist');

   Result := TEApplicationGroup.Create;
   Result.Name := aName;
   Add(aName, Result);
End;

Constructor TEApplicationGroups.Create;
Begin
   Inherited Create([doOwnsValues]);

   FIsLoaded := False;
End;

Function TEApplicationGroups.DeleteGroup(const aFileName, aGroupName: String): Boolean;
Var
   varIniFile: TIniFile;
Begin
   Result := False;
   varIniFile := TIniFile.Create(aFileName);
   Try
      If Not varIniFile.SectionExists(aGroupName) Then
         Exit;

      Remove(aGroupName);
      varIniFile.EraseSection(aGroupName);
      Result := True;
   Finally
      varIniFile.Free;
   End;
End;

Procedure TEApplicationGroups.LoadData(Const aFileName: String);
Var
   varIniFile: TIniFile;
   varList: TStringList;
   iCntr: Integer;
   sCurrName: String;
   varCurrAppGrp: TEApplicationGroup;
Begin
   varIniFile := TIniFile.Create(aFileName);
   varList := TStringList.Create;
   varList.Duplicates := dupIgnore;
   varList.Sorted := True;
   Try
      Try
         varIniFile.ReadSections(varList);
      Finally
         varIniFile.Free;
      End;
      For iCntr := 0 To Pred(varList.Count) Do
      Begin
         sCurrName := varList[iCntr];
         If sCurrName = '' Then
            Continue;

         varCurrAppGrp := AddItem(sCurrName);
         If Not Assigned(varCurrAppGrp) Then
            Continue; // A group with same name already exist. { Ajmal }

         varCurrAppGrp.LoadData(aFileName);
      End;
      FIsLoaded := True;
   Finally
      varList.Free;
   End;
End;

Procedure TEApplicationGroups.SaveData(Const aFileName: String);
Var
   varCurrAppGrp: TEApplicationGroup;
Begin
   If Not FIsLoaded Then
      Exit; // Don't save if it's not loaded. { Ajmal }

   DeleteFile(aFileName);
   For varCurrAppGrp In Values Do
      varCurrAppGrp.SaveData(aFileName);
End;

{ TEApplication }

Function TEApplication.BuildNumber: Integer;
var
   iLen: Integer;
Begin
   If Not Owner.IsBranchingEnabled Then
      Exit(cInvalidBuildNumber);

   Try
      iLen := Length(VersionName);
      If iLen >= cBRANCH_BUILD_VERSION Then
         Result := StrToInt(Trim(VersionName[cBRANCH_BUILD_VERSION]))
      Else If iLen <> 0 Then         
         Result := StrToInt(Trim(VersionName[Length(VersionName) - 1])); // Try to get the last number at least { Ajmal }
   Except
      Result := cInvalidBuildNumber;
   End;
End;

Constructor TEApplication.Create(Const aOwner: TEApplicationGroup);
Begin
   Assert(aOwner <> Nil, 'Owner cannot be nil');
   Owner := aOwner;
   SetLength(FVersionName, 0);
   FLastUsedParamName := '';
End;

Function TEApplication.GetActualName: String;
Begin
   Result := Name;
End;

Function TEApplication.GetFileName(aType: eTAppFile): String;
Begin
   Case aType Of
      eafName:
         Result := Copy(FFileName, 1, Length(FFileName) - Length(ExtractFileExt(FFileName)));
      eafFileName:
         Result := FFileName;
      eafExtension:
         Result := ExtractFileExt(FFileName);
   End;
End;

function TEApplication.GetFixedParameter: String;
begin
   Result := Owner.FixedParameter;
end;

function TEApplication.GetISFixedParameter: Boolean;
begin
   Result := Owner.ISFixedParameter;
end;

Function TEApplication.GetLastUsedParamName: String;
Begin
   Result := FLastUsedParamName;
End;

Function TEApplication.MajorVersionName: String;
Begin
   If Not Owner.IsMajorBranching Then
      Exit('');

   Try
      Result := 'Version ' + Trim(VersionName[cBRANCH_MAJOR_VERSION]);
   Except
      Result := '';
   End;
End;

Function TEApplication.MinorVersionName: String;
Begin
   If Not Owner.IsMinorBranching Then
      Exit('');

   Try
      Result := Format('Version %s.%s', [Trim(VersionName[cBRANCH_MAJOR_VERSION]), Trim(VersionName[cBRANCH_MINOR_VERSION])]);
   Except
      Result := '';
   End;
End;

Function TEApplication.QueryInterface(Const IID: TGUID; Out Obj): HRESULT;
Begin
   Inherited;
End;

Function TEApplication.ReleaseVersionName: String;
Var
   sRelease: String;
Begin
   If Not Owner.IsReleaseBranching Then
      Exit('');

   Try
      sRelease := Trim(VersionName[cBRANCH_RELEASE_VERSION]);
      If SameStr(sRelease, IntToStr(Owner.MainBranch)) Then
         Result := 'Main Release'
      Else If SameStr(sRelease, IntToStr(Owner.CurrentBranch)) Then
         Result := 'Current Release'
      Else
         Result := 'Release ' + sRelease;
   Except
      Result := '';
   End;
End;

Function TEApplication.CopyFromSourceFolder: Boolean;
var
   varDownloader: IEDownloadManager;
   bVisible: Boolean;
Begin
   Result := False;
   If Not Owner.NeedToCopy Then
      Exit(True);

   bVisible := FormMDIMain.Visible;
   If Not (bVisible Or (Assigned(FormParameterBrowser) And FormParameterBrowser.Visible)) Then
   Begin
     FormMDIMain.Visible := True;
     FormMDIMain.WindowState := wsMinimized;
   End;
   Try
   If FileExists(Owner.SourceFolderCopyTo + FileName) And (MessageDlg('The file already exsit, do you want to download again ?', mtConfirmation, [mbYes, mbNo], 0, mbNo) = mrNo) Then
      Exit(False);
   Finally
      FormMDIMain.Visible := bVisible;
   End;

   varDownloader := TEDownloadManager.Create(Application.MainForm);
   varDownloader.Add(Owner.SourceFolderPrefix + Owner.SourceFolder + FileName, Owner.SourceFolderCopyTo + FileName);
   Try
      Result := varDownloader.Download;
   Except
      On E:Exception Do
         MessageDlg(E.Message, mtError, [mbOK], 0);
   End;
End;

Function TEApplication.RunExecutable(aParameter: String): Boolean;
var
   sFileName: String;
   sTargetFolder: String;
Begin
   If ISFixedParameter Then
      aParameter := aParameter + ' ' + Owner.FixedParameter;

   sFileName := Owner.ExecutableName;
   sTargetFolder := TargetFolder;
   // If Owner.ExecutableName is empty, it means this is a group of different files [Not extractable] { Ajmal }
   If Owner.ExecutableName = '' Then
   Begin
      sFileName := FileName;
      sTargetFolder := Owner.FinalSourceFolder;
   End;

   FormMDIMain.RunApplication(Name, sFileName, aParameter, sTargetFolder, Owner.SkipFromRecent);
End;

procedure TEApplication.SetLastUsedParamName(const aValue: String);
begin
   FLastUsedParamName := aValue;
   // We need to store this into group also { Ajmal }
   Owner.LastUsedParamName := aValue;
end;

Procedure TEApplication.SetOwner(Const Value: TEApplicationGroup);
Begin
   FOwner := Value;
End;

Function TEApplication.TargetBranchPath: String;
Begin
   Result := '';
   If Not Owner.CreateBranchFolder Then
      Exit;

   If Owner.IsMajorBranching Then
      Result := IncludeTrailingBackslash(MajorVersionName + '.x');

   If Owner.IsMinorBranching Then
      Result := Result + IncludeTrailingBackslash(MinorVersionName);

   If Owner.IsReleaseBranching Then
      Result := Result + IncludeTrailingBackslash(ReleaseVersionName);
End;

Function TEApplication.TargetFolder: String;
Begin
   If Owner.CreateFolder Then
      Result := IncludeTrailingBackslash(Owner.DestFolder) + TargetBranchPath + Name
   Else
      Result := Owner.DestFolder;
End;

Function TEApplication.UnZip: Boolean;
Var
   varZipObj: TObject;
{$IFDEF AbbreviaZipper}
   varUnAbZipper: TAbUnZipper Absolute varZipObj;
Begin
   If Owner.GroupType <> cGroupType_ZipFiles Then
      Exit(False);

   varZipObj := TAbUnZipper.Create(Nil);
   If Assigned(FormParameterBrowser) Then
   Begin
      varUnAbZipper.ArchiveProgressMeter := TAbProgressBar(FormParameterBrowser.ZipProgressBarArchive);
      varUnAbZipper.ItemProgressMeter := TAbProgressBar(FormParameterBrowser.ZipProgressBarItem);
   End;
{$ELSE}
   varZipFile: TZipFile Absolute varZipObj;
Begin
   varZipObj := TZipFile.Create;
{$ENDIF}
   Result := False;
   Try
      If Not SameText(Extension, '.zip') Then
         Exit(False); // This will go to finally before function exit. So objected ll be freed. { Ajmal }

      If DirectoryExists(TargetFolder) Then
         Exit;
      ForceDirectories(TargetFolder);
{$IFDEF AbbreviaZipper}
      varUnAbZipper.FileName := Owner.FinalSourceFolder + FileName;
      varUnAbZipper.BaseDirectory := TargetFolder;
      varUnAbZipper.ExtractOptions := [eoCreateDirs, eoRestorePath];
      varUnAbZipper.ExtractFiles('*.*');
{$ELSE}
      varZipFile.ExtractZipFile(Owner.FinalSourceFolder + FileName, sDestFolder);
{$ENDIF}
      Result := True;
   Finally
      varZipObj.Free;
   End;
End;

Function TEApplication.VersionName: TStringDynArray;
Var
   sVersion: String;
Begin
   If Not Owner.IsBranchingEnabled Then
   Begin
      SetLength(FVersionName, 0);
      Exit(FVersionName);
   End;

   // Check we already loaded the version name { Ajmal }
   If Length(FVersionName) <> 0 Then
      Exit(FVersionName);

   sVersion := Name;

   If (Owner.BranchingPrefix <> '') And StrStartsWith(Name, Owner.BranchingPrefix, False) Then
      sVersion := StringReplace(sVersion, Owner.BranchingPrefix, '', [rfIgnoreCase]);

   If (Owner.BranchingSufix <> '') And StrEndsWith(Name, Owner.BranchingSufix) Then
      sVersion := StrSubString(Length(Owner.BranchingSufix), sVersion);

   Result:= SplitString(sVersion, cBRANCH_VERSION_SEPERATOR);
End;

Function TEApplication._AddRef: Integer;
Begin
   Inherited;
End;

Function TEApplication._Release: Integer;
Begin
   Inherited;
End;

End.
