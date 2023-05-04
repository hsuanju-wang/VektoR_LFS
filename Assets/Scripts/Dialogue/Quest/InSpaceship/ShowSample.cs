using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowSample : Quest
{
    public GameObject samples;

    public override void StartQuest()
    {
        base.StartQuest();
        StartCoroutine(ShowSamples());
        base.EndQuest();
        
    }

    private IEnumerator ShowSamples()
    {
        samples.SetActive(true);
        yield return new WaitForSeconds(5f);
        samples.SetActive(false);
    }
}
