using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InCabinDM : DialogueManager
{
    [Header("Bg settings Before First Dialogue Starts")]
    public Sprite blueUISprite;
    public Image bgImage;
    public GameObject lockedScreenImgs;

    protected override IEnumerator StartFirstDialogue()
    {
        yield return new WaitForSeconds(introDelayedTime);
        bgImage.sprite = blueUISprite;
        lockedScreenImgs.SetActive(false);
        StartDialogue(dialogues[0]);
    }
}
