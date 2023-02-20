using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class DOFLerp : MonoBehaviour
{
    public Volume volume;
    DepthOfField dof;
    public float maxDof = 200f;
    public float minDof = 50f;
    float lerp = 0f;
    public float duration = 5f;
    // Start is called before the first frame update
    void Start()
    {
        if (volume.profile.TryGet<DepthOfField>(out dof))
        {
            //Do Nothing
        }
    }

    // Update is called once per frame
    void Update()
    {
        lerp += Time.deltaTime / duration;
        dof.focalLength.value = Mathf.Lerp(maxDof, minDof, lerp);
    }
}
