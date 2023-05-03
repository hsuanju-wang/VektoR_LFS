using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleHandler : MonoBehaviour
{
    public static SampleHandler s;
    public GameObject[] sample;
    public GameObject[] sampleInScanMode;
    public GameObject[] grass;

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
        //sample = GameObject.FindGameObjectsWithTag("sample");
        //sampleInScanMode = GameObject.FindGameObjectsWithTag("sampleInScanMode");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void CloseSampleInScanMode(GameObject collectedSample)
    {
        int i = System.Array.IndexOf(sample, collectedSample);
        sampleInScanMode[i].SetActive(false);
        collectedSample.gameObject.SetActive(false);
    }

    public void GrassGrow(GameObject collectedSample)
    {
        int i = System.Array.IndexOf(sample, collectedSample);
        grass[i].SetActive(true);
    }
}
