// Set Skill Points Per Level 3.x by pMarK

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

@addField(W3LevelManager)
private var mSetSkillPointsPerLevel : SetSkillPointsPerLevelManager;

@replaceMethod(W3LevelManager)
function GainLevel( show : bool ) : bool
{
	var totalExp : int;
	var newLevelDef : SLevelDefinition;
	var skillPoints : int;
	
	if(level == GetMaxLevel())
	{
		LogAssert(false, "W3LevelManager.GainLevel: already at max level, so why trying to gain a level?");
		return false;
	}

	level += 1;

	newLevelDef = GetLevelDefinition(level);

	totalExp = points[EExperiencePoint].used + points[EExperiencePoint].free;

	points[EExperiencePoint].used = newLevelDef.requiredTotalExp;
	points[EExperiencePoint].free = totalExp - points[EExperiencePoint].used;

	theTelemetry.LogWithValue(TE_HERO_LEVEL_UP, level);

	if (!mSetSkillPointsPerLevel)
	{
		mSetSkillPointsPerLevel = new SetSkillPointsPerLevelManager in this;
	}

	if(mSetSkillPointsPerLevel.GetIsModOn())
	{
		skillPoints = mSetSkillPointsPerLevel.GetSkillPointsPerLevelValue();
		if(skillPoints > 0)
			AddPoints(ESkillPoint, skillPoints, show);
	}
	else if(newLevelDef.addedSkillPoints > 0)
		AddPoints(ESkillPoint, newLevelDef.addedSkillPoints, show);

	owner.OnLevelGained(level, show);

	return true;
}
