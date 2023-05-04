using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightControl : MonoBehaviour
{
    public static LightControl s;

    public GameObject lightDim;
    public GameObject lightActive;
    public Material[] materials;

    private void Awake()
    {
        s = this;    
    }

    private void Start()
    {
        LightOffConsole();
    }

    public void LightUpConsole()
    {
        StartCoroutine(StartLightUpConsole());
    }

    private IEnumerator StartLightUpConsole()
    {
        foreach (Material material in materials)
        {
            material.SetFloat("EmissionStrength", 1);
            yield return new WaitForSeconds(0.7f);
        }
        lightDim.SetActive(false);
        lightActive.SetActive(true);
    }

    private void LightOffConsole()
    {
        foreach (Material material in materials)
        {
            //material.shader.GetPropertyCount();
            material.SetFloat("EmissionStrength", -1);
        }
    }
}
