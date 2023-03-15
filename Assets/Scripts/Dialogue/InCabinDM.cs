using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InCabinDM : DialogueManager
{
    [Header("Background")]
    public Sprite bgSprite;
    public Image bgImage;
    public GameObject lockedScreenImgs;

    // Start is called before the first frame update
    protected override void Start()
    {
        base.Start();
        StartCoroutine(StartIntroInCabin());
    }

    private IEnumerator StartIntroInCabin()
    {
        yield return new WaitForSeconds(introDelayedTime);
        bgImage.sprite = bgSprite;
        lockedScreenImgs.SetActive(false);
        StartDialogue(dialogues[0]);
    }
}
