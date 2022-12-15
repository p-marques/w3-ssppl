// Set Skill Points Per Level 2.x by pMarK

class SetSkillPointsPerLevelManager {

	private var inGameConfigWrapper : CInGameConfigWrapper;

	public function GetIsModOn() : bool
	{
		if (!inGameConfigWrapper)
		{
			inGameConfigWrapper = theGame.GetInGameConfigWrapper();
		}

		return inGameConfigWrapper.GetVarValue('SetSkillPointsPerLevel', 'SetSkillPointsPerLevelSwitch');
	}

	public function GetSkillPointsPerLevelValue() : int
	{
		return (int)StringToFloat(inGameConfigWrapper.GetVarValue('SetSkillPointsPerLevel', 'SetSkillPointsPerLevelValue'));
	}
}