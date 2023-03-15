using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowSample : Task
{
    public GameObject samples;

    public override void StartTask()
    {
        base.StartTask();
        StartCoroutine(ShowSamples());
        base.EndTask();
        
    }

    private IEnumerator ShowSamples()
    {
        samples.SetActive(true);
        yield return new WaitForSeconds(5f);
        samples.SetActive(false);
    }
}
