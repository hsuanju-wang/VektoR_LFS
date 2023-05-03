using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CollectHandler : MonoBehaviour
{
    /// <summary>
    /// This class handles the interaction of collecting the samples. 
    /// </summary>
    
    public static CollectHandler s;
    public TextMeshProUGUI txtNum;
    public GameObject collectPanel;
    public GameObject laser;


    public int collectedSamples;

    public Material originalMat;
    public Material dissolveMat;

    public bool isCollecting;
    public float duration = 3.0f;

    public GameObject rightControllerTask;

    

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }

    void Start()
    {
        collectedSamples = 0;
        isCollecting = false;
    }

    // Called by Laser.cs: If the laser collides with the sample.
    public void StartDissolveSample(GameObject sample)
    {
        StartCoroutine(DissolveSample(sample));
    }

    private IEnumerator DissolveSample(GameObject sample)
    {
        Renderer rend = sample.GetComponent<Renderer>();
        float triggerHeldTime = 0;
        while (triggerHeldTime < duration)
        {
            if (!isCollecting)
            {
                break;
            }
            rend.material.Lerp(originalMat, dissolveMat, triggerHeldTime / duration);
            triggerHeldTime += Time.deltaTime;
            yield return null;
        }

        if (triggerHeldTime >= duration) // Sample Collected if trigger held more then 3f
        {
            Collect(sample);
        }
        else // Sample Started redissolve if trigger held less then 3f
        {
            StartCoroutine(RedissolveSample(triggerHeldTime, sample));
        }
    }

    private IEnumerator RedissolveSample( float prevTriggerHeldTime, GameObject sample)
    {
        Debug.Log("RedissolveSample");
        Renderer rend = sample.GetComponent<Renderer>();
        while (prevTriggerHeldTime > 0f)
        {
            rend.material.Lerp(originalMat, dissolveMat, prevTriggerHeldTime / duration);
            prevTriggerHeldTime -= Time.deltaTime * 2;
            yield return null;
        }
    }


    private void Collect( GameObject sample)
    {
        sample.SetActive(false); // close collected sample
        SampleHandler.s.CloseSampleInScanMode(sample); // close collected sample in scan mode
        SampleHandler.s.GrassGrow(sample); // grow grass

        // Change collected UI on controller
        collectedSamples++;
        txtNum.text = collectedSamples.ToString() + "/3";
        OutsideSM.s.PlayCollectSound();

        // First sample collected is for tutorial 
        if (collectedSamples == 1)
        {
            if (rightControllerTask.GetComponent<ControllerTask>().isTaskStart && !rightControllerTask.GetComponent<ControllerTask>().isTaskEnd)
            {
                rightControllerTask.GetComponent<Task>().EndTask();
                OutsideDM.s.CloseDialogueUI();
                OutsideDM.s.dialogueIsEnd = true;
            }
        }
        else if (collectedSamples == 2)
        {
            OutsideDM.s.PlaySampleCollected();
        }
        else if (collectedSamples == 3)
        {
            EndHandler.s.End();
        }
    }
}
