using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CollectHandler : MonoBehaviour
{
    public TextMeshProUGUI txtNum;
    public int collectedSamples;

    public Material originalMat;
    public Material dissolveMat;
    float duration = 3.0f;
    

    //float triggerHeldTime;
    public bool isCollecting;

    // Start is called before the first frame update
    void Start()
    {
        collectedSamples = 0;
        isCollecting = false;
    }

    // Update is called once per frame
    void Update()
    {

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
        else
        {
            StartCoroutine(RedissolveSample(triggerHeldTime, sample));
        }
    }

    public void StartDissolveSample(GameObject sample)
    {
        StartCoroutine(DissolveSample(sample));
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
        Destroy(sample);
        collectedSamples++;
        txtNum.text = collectedSamples.ToString() + "/3";
    }
}
