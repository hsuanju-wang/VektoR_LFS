using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinishTask1 : Quest
{
    private SoundManager soundManager;

    public override void StartQuest()
    {
        base.StartQuest();
        soundManager = FindObjectOfType<SoundManager>();
    }

    public override void EndQuest()
    {
        dialogueManager.CloseDialoguePanel();
        StartCoroutine(PlaySound());
        LightControl.s.LightUpConsole();
    }

    private IEnumerator PlaySound()
    {
        float soundLength = soundManager.PlayPowerOn();
        yield return new WaitForSeconds(soundLength);
        base.EndQuest();
    }
}
